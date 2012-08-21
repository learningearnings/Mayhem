require_relative '../test_helper'

describe BuckDistributor do
  before do
    @credit_manager = mock 'credit_manager'
  end

  it "is a thing" do
    @schools = mock 'schools'
    @buck_distributor = BuckDistributor.new @schools, @credit_manager
    @buck_distributor.must_be_instance_of BuckDistributor
  end

  describe "handling schools" do
    before do
      @school = mock 'school'
      @schools = [@school]
      @buck_distributor = BuckDistributor.new @schools, @credit_manager
    end

    it "responds to #pay_school" do
      @amount = BigDecimal('20')
      @credit_manager.expects(:issue_credits_to_school).with(@school, @amount).once
      @buck_distributor.expects(:amount_for_school).with(@school).returns(@amount)
      @buck_distributor.pay_school(@school)
    end

    it "responds to #handle_schools" do
      balance = BigDecimal('100')
      @school.expects(:balance).returns(balance)
      @credit_manager.expects(:revoke_credits_for_school).with(@school, balance)
      @buck_distributor.expects(:pay_school).with(@school)
      @buck_distributor.handle_schools
    end

    it "knows the amount for a given school" do
      @school.expects(:number_of_active_students).returns(2)
      @buck_distributor.amount_for_school(@school).must_equal(1400)
    end
  end

  describe "handling teachers" do
    before do
      @school = mock 'school'
      @schools = [@school]
      @teacher = mock 'teacher'
      @teachers = [@teacher]
      @buck_distributor = BuckDistributor.new @schools, @credit_manager
    end

    it "responds to #pay_teacher" do
      @amount = BigDecimal('20')
      @credit_manager.expects(:issue_credits_to_teacher).with(@school, @teacher, @amount).once
      @buck_distributor.expects(:amount_for_teacher).with(@school).returns(@amount)
      @buck_distributor.pay_teacher(@school, @teacher)
    end

    it "responds to #handle_teachers" do
      @school.expects(:active_teachers).returns(@teachers)
      @buck_distributor.expects(:pay_teacher).with(@school, @teacher)
      @buck_distributor.handle_teachers
    end

    it "knows the amount for a given teacher" do
      balance = BigDecimal('100')
      @school.expects(:balance).returns(balance)
      @school.expects(:number_of_participating_teachers).returns(2)
      @buck_distributor.amount_for_teacher(@school).must_equal(50)
    end
 
  end
end
