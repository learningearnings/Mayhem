module Reports
  class NewUserActivityReport
    attr_reader :beginning_day, :ending_day, :total_days, :scoped_schools, :scoped_teachers, :scoped_students, :scoped_reward_deliveries, :scoped_otu_codes

    def initialize options = {}
      if options.has_key?("beginning_day")
        @beginning_day = Time.zone.parse(options["beginning_day"]).beginning_of_day
      else
        @beginning_day = (Time.zone.now - 30.days).beginning_of_day
      end
      if options.has_key?("ending_day")
        @ending_day = Time.zone.parse(options["ending_day"]).end_of_day
      else
        @ending_day = Time.zone.now.end_of_day
      end
      @total_days = (@ending_day.to_date - @beginning_day.to_date).to_i
      school_ids = options.fetch("school_ids", nil)
      if school_ids.present?
        @scoped_schools = School.where(id: school_ids)
        @scoped_teachers = Teacher.joins(:person_school_links).where(status: "active", person_school_links: { school_id: school_ids, status: "active" }).uniq
        @scoped_students = Student.joins(:person_school_links).where(status: "active", grade: School::GRADES, person_school_links: { school_id: school_ids, status: "active" }).uniq
        @scoped_otu_codes = OtuCode.joins(:person_school_link).where(person_school_link: { school_id: school_ids }).uniq
        @scoped_reward_deliveries = RewardDelivery.where(from_id: @scoped_teachers.pluck(:id))
      else
        @scoped_schools = School
        @scoped_teachers = Teacher.joins(:person_school_links).where(status: "active", grade: School::GRADES, person_school_links: { status: "active" }).uniq
        @scoped_students = Student.joins(:person_school_links).where(status: "active", person_school_links: { status: "active" }).uniq
        @scoped_otu_codes = OtuCode
        @scoped_reward_deliveries = RewardDelivery
      end
    end

    def run
      csv = CSV.generate do |csv|
        csv << ["", "", "Teachers Count", "#{total_days} Day Active Teachers", "7 Day New Teachers", "Students Count", "#{total_days} Day Active Students", "7 Day New Students", "#{total_days} Day Purchases Count", "Student Balance", "#{total_days} Day Credits Deposited", "#{total_days} Day Credits Spent", "Teachers Issued Credits Count", "Students Deposited Credits Count"]

        csv << build_global_row

        # By Grade
        csv << ["By Grade"]
        School::GRADES.each do |grade|
          csv << build_grade_row(grade)
        end

        csv << ["By School"]
        # By School
        scoped_schools.find_each do |school|
          school_row = build_school_row(school)
          csv << school_row unless school_row.nil?
        end
      end
      csv
    end

    private
    def build_global_row
      # Totals system wide
      teacher_scope = scoped_teachers
      student_scope = scoped_students
      reward_delivery_scope = scoped_reward_deliveries
      otu_code_scope = scoped_otu_codes
      build_row("Total", teacher_scope, student_scope, reward_delivery_scope, otu_code_scope)
    end

    def build_grade_row grade
      # FIXME: Grades 97, 98, 99 are Pre-K and should be lumped into grade 0
      #  This should be solved differently than right here
      grade = [0, 97, 98, 99] if grade == 0
      teacher_scope = scoped_teachers.where(grade: grade)
      student_scope = scoped_students.where(grade: grade)
      otu_code_scope = scoped_otu_codes.for_grade(grade)
      reward_delivery_scope = scoped_reward_deliveries.joins(:to).where(to: {grade: grade})
      build_row(grade, teacher_scope, student_scope, reward_delivery_scope, otu_code_scope)
    end

    def build_school_row(school)
      teacher_scope = school.teachers.uniq
      student_scope = school.students.uniq
      return nil if teacher_scope.count == 0 || student_scope.count  == 0
      otu_code_scope = scoped_otu_codes.for_school(school)
      reward_delivery_scope = RewardDelivery.where(from_id: school.teachers.pluck(:id))
      build_row(school.name, teacher_scope, student_scope, reward_delivery_scope, otu_code_scope)
    end

    def build_row title, teacher_scope, student_scope, reward_delivery_scope, otu_code_scope
      [].tap do |csv_array|
        csv_array << title
        csv_array << ""
        csv_array << total(teacher_scope)
        csv_array << active(teacher_scope)
        csv_array << new(teacher_scope)
        csv_array << total(student_scope)
        csv_array << active(student_scope)
        csv_array << new(student_scope)
        csv_array << total_redemptions(reward_delivery_scope)
        csv_array << Plutus::Account.where(id: student_scope.pluck(:checking_account_id) + student_scope.pluck(:savings_account_id)).sum(:cached_balance)
        csv_array << otu_code_scope.redeemed_between(beginning_day, ending_day).sum(:points)
        csv_array << Spree::LineItem.where(id: reward_delivery_scope.except_refunded.between(beginning_day, ending_day).pluck(:reward_id)).sum(:price)
        csv_array << teacher_issued_credits_count(teacher_scope) 
        csv_array << otu_code_scope.redeemed_between(beginning_day, ending_day).where(student_id: student_scope.pluck(:id)).count
      end
    end

    # FIXME: Understand how this works better, so that this can be done better
    def teacher_issued_credits_count teacher_scope
      count = 0
      teacher_scope.find_each do |teacher|
        count += 1 if teacher.plutus_transactions.where("description ilike '%ebucks for student%'").where(created_at: beginning_day..ending_day).any?
      end
      count
    end

    def total scope
      scope.created_before(ending_day).uniq.count
    end

    def active scope
      Interaction.between(beginning_day, ending_day).where(:person_id => scope.pluck(:id)).pluck(:person_id).uniq.count
    end

    def new scope
      scope.created_between(ending_day - 7.days, ending_day).uniq.count
    end

    def total_redemptions scope
      scope.except_refunded.between(beginning_day, ending_day).uniq.count
    end
  end
end
