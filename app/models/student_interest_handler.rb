require 'chronic'

class StudentInterestHandler

  def initialize(admin=nil, forced_run=nil)
    @admin = admin
    @forced_run = forced_run
    @students = Student.recently_logged_in
    @site_setting = SiteSetting.last
    @rate = ((@site_setting.student_interest_rate / 52) * 0.01)
    @credit_manager = CreditManager.new
  end

  def call
    # admin can run any day of the week but do not let it run twice even if it
    # has already been processed.
    if @admin && !ran_this_week?
      pay_students

    # do not let it run unless today is saturday and it has not been run today
    elsif Date.today.saturday? && !ran_today?
      pay_students
    elsif @forced_run
      pay_students
    end
  end

  def pay_students
    @students.each do |student|
      calculate_and_pay(student)
    end
    @site_setting.update_attributes(interest_paid_at: Time.now)
  end

  def calculate_and_pay(student)
    if student.savings_account.balance > 0.00
      amount = student.savings_account.balance * @rate
      otu_code = OtuCode.create(:expires_at => (Time.now + 45.days),
        :student_id => student.id,
        :ebuck => true,
        :points => BigDecimal.new(amount)
      otu_code.mark_redeemed!
      @credit_manager.issue_interest_to_student student, amount, otu_code
    end
  end

  def ran_last_saturday?
    bod = Chronic.parse('last saturday')
    eod = Chronic.parse('last saturday').end_of_day
    (bod..eod).cover? @site_setting.interest_paid_at
  end

  def ran_today?
    bod = Chronic.parse('today')
    eod = Chronic.parse('today').end_of_day
    (bod..eod).cover? @site_setting.interest_paid_at
  end

  def ran_this_week?
    bow = Chronic.parse('last sunday')
    eow = Chronic.parse('saturday').end_of_day
    (bow..eow).cover? @site_setting.interest_paid_at
  end

end