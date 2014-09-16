module Reports
  class NewUserActivityReport
    attr_reader :ending_day

    def initialize options = {}
      @ending_day = options.fetch(:ending_day, Time.zone.now).end_of_day
      @school = options.fetch(:school)
    end

    def run
      csv = CSV.generate do |csv|
        csv << ["", "", "Teachers Count", "30 Day Active Teachers", "7 Day New Teachers", "Students Count", "30 Day Active Students", "7 Day New Students", "30 Day Purchases Count", "Student Balance", "30 Day Credits Deposited", "30 Day Credits Spent"]

        csv << build_global_row

        # By Grade
        csv << ["By Grade"]
        School::GRADES.each do |grade|
          csv << build_grade_row(grade)
        end

        csv << ["By School"]
        # By School
        School.find_each do |school|
          school_row = build_school_row(school)
          csv << school_row unless school_row.nil?
        end
      end
      csv
    end

    private
    def build_global_row
      # Totals system wide
      teacher_scope = Teacher
      student_scope = Student
      reward_delivery_scope = RewardDelivery
      otu_code_scope = OtuCode
      build_row("Total", teacher_scope, student_scope, reward_delivery_scope, otu_code_scope)
    end

    def build_grade_row grade
      teacher_scope = Teacher.where(grade: grade)
      student_scope = Student.where(grade: grade)
      otu_code_scope = OtuCode.for_grade(grade)
      reward_delivery_scope = RewardDelivery.joins(:to).where(to: {grade: grade})
      build_row(grade, teacher_scope, student_scope, reward_delivery_scope, otu_code_scope)
    end

    def build_school_row(school)
      teacher_scope = school.teachers
      student_scope = school.students
      return nil if teacher_scope.count == 0 || student_scope.count  == 0
      otu_code_scope = OtuCode.for_school(school)
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
        csv_array << otu_code_scope.redeemed_between(ending_day - 30.days, ending_day).sum(:points)
        csv_array << Spree::LineItem.where(id: reward_delivery_scope.except_refunded.between(ending_day - 30.days, ending_day).pluck(:reward_id)).sum(:price)
      end
    end

    def total scope
      scope.created_before(ending_day).count
    end

    def active scope
      Interaction.between(ending_day - 1.month, ending_day).where(:person_id => scope.pluck(:id)).pluck(:person_id).uniq.count
    end

    def new scope
      scope.created_between(ending_day - 7.days, ending_day).count
    end

    def total_redemptions scope
      scope.except_refunded.between(ending_day - 30.days, ending_day).count
    end
  end
end
