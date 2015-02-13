class Jobs::Weekly::AwardAutomaticCredits
  #include Jobs::Logger

  def initialize(school_id)
    @school = School.find(school_id)
    @start_time = Time.zone.now.beginning_of_week.strftime("%Y-%m-%d")
    @end_date = Time.zone.now.end_of_week.strftime("%Y-%m-%d")
  end

  def run
    return unless sti_link_token
    distribute_credits(:weekly_no_infractions_amount, :no_infractions, "Weekly Credits for No Infractions")
    distribute_credits(:weekly_perfect_attendance_amount, :perfect_attendance, "Weekly Credits for Perfect Attendance")
    distribute_credits(:weekly_no_tardies_amount, :no_tardies, "Weekly Credits for No Tardies")
  end

  private

  def distribute_credits(school_method, client_method, message)
    if @school.send(school_method).present?
      sti_ids = sti_client.send(client_method, @school.sti_id, @start_date, @end_date)
      students = Student.where(district_guid: @school.district_guid, sti_id: sti_ids)
      students.each do |student|
        expire_cache_for_student(student.id)
        credit_manager.issue_weekly_automatic_credits_to-student(message, @school, student, @school.send(school_method))
      end
    end
  end

  def sti_client
    @sti_client = STI::Client.new(
      base_url: sti_link_token.api_url,
      username: sti_link_token.username,
      password: sti_link_token.password
    )
  end

  def credit_manager
    @credit_manager ||= CreditManager.new
  end

  def sti_link_token
    @sti_link_token ||= StiLinkToken.where(district_guid: @school.district_guid).first
  end

  def expire_cache_for_student(student_id)
    ActionController::Base.new.expire_fragment("#{student_id}_balances")
  end
end
