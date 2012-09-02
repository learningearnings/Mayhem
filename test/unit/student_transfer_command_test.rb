require 'test_helper'
require_relative '../../app/models/student_transfer_command'

describe StudentTransferCommand do
  subject { StudentTransferCommand.new }

  it "requires valid amount" do
    subject.wont have_valid(:amount).when(nil)
    subject.wont have_valid(:amount).when(0)
    subject.wont have_valid(:amount).when(BigDecimal('-1'))
    subject.wont have_valid(:amount).when('asdf')
    subject.wont have_valid(:amount).when('123')

    subject.must have_valid(:amount).when(BigDecimal('1'))
  end

  it "requires valid direction" do
    subject.wont have_valid(:direction).when(nil)
    subject.wont have_valid(:direction).when("foo")

    subject.must have_valid(:direction).when("savings_to_checking")
    subject.must have_valid(:direction).when("checking_to_savings")
  end

  it "requires valid student_id" do
    subject.wont have_valid(:student_id).when(nil)
    subject.wont have_valid(:student_id).when("foo")

    subject.must have_valid(:student_id).when(1)
  end

  it "knows the type of credit manager transfer to execute based on its direction" do
    subject.direction = "checking_to_savings"
    subject.transfer_method.must_equal :transfer_credits_from_checking_to_savings

    subject.direction = "savings_to_checking"
    subject.transfer_method.must_equal :transfer_credits_from_savings_to_checking
  end

  it "executes the appropriate transfer when #execute! is called" do
    amount = BigDecimal('5')
    subject.amount = amount
    method = :meth
    student = mock "student"
    credit_manager = mock "credit manager"
    subject.expects(:student).returns(student)
    subject.expects(:credit_manager).returns(credit_manager)
    credit_manager.expects(method).with(student, amount).returns(true)
    subject.expects(:transfer_method).returns(method)

    subject.execute!
  end
end
