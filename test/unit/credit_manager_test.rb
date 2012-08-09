require_relative '../test_helper'

describe CreditManager do
  before do
    @transaction_class = mock "Plutus::Transaction"
    @credit_manager = CreditManager.new(transaction_class: @transaction_class)
  end

  it "is a thing" do
    @credit_manager.must_be_instance_of CreditManager
  end

  it "can transfer credits between two accounts" do
    @account1 = "Foo"
    @account2 = "Bar"
    @amount = BigDecimal("500.00")
    # We want to verify that our credit manager uses Plutus::Transaction appropriately
    @mock_transaction = mock "Plutus::Transaction instance"
    @description = "Credit Transfer"
    @transaction_class.expects(:build).with({
      description: @description,
      debits:      [{ account: @account2, amount: @amount }],
      credits:     [{ account: @account1, amount: @amount }]
    }).returns(@mock_transaction)
    @mock_transaction.expects(:save).once
    @credit_manager.transfer_credits(@description, @account1, @account2, @amount)
  end

  describe "dealing with a school" do
    before do
      @school_account_name = "SCHOOLfoo"
      @school = mock "school"
    end

    it "issues credits to a school" do
      @school.expects(:account_name).returns(@school_account_name)
      @amount = BigDecimal("500.00")
      @credit_manager.expects(:transfer_credits).with("Issue Credits to School", @credit_manager.main_account_name, @school_account_name, @amount).once
      @credit_manager.issue_credits_to_school(@school, @amount)
    end

    it "revokes credits from a school" do
      @school.expects(:account_name).returns(@school_account_name)
      @amount = BigDecimal("500.00")
      @credit_manager.expects(:transfer_credits).with("Revoke Credits for School", @school_account_name, @credit_manager.main_account_name, @amount).once
      @credit_manager.revoke_credits_for_school(@school, @amount)
    end

    describe "dealing with a teacher" do
      before do
        @teacher_account_name = "TEACHER17"
        @teacher = mock "teacher"
      end

      it "issues credits to a teacher" do
        @school.expects(:account_name).returns(@school_account_name)
        @teacher.expects(:account_name).returns(@teacher_account_name)
        @amount = BigDecimal("500.00")
        @credit_manager.expects(:transfer_credits).with("Issue Credits to Teacher", @school_account_name, @teacher_account_name, @amount).once
        @credit_manager.issue_credits_to_teacher(@school, @teacher, @amount)
      end

      describe "dealing with a student" do
        before do
          @student_account_name = "STUDENT17"
          @student = mock "student"
          @student.expects(:account_name).returns(@student_account_name)
        end

        it "issues credits to a student" do
          @amount = BigDecimal("500.00")
          @teacher.expects(:account_name).returns(@teacher_account_name)
          @credit_manager.expects(:transfer_credits).with("Issue Credits to Student", @teacher_account_name, @student_account_name, @amount).once
          @credit_manager.issue_credits_to_student(@school, @teacher, @student, @amount)
        end

        it "transfers credits from a student for reward purchase" do
          @amount = BigDecimal("500.00")
          @credit_manager.expects(:transfer_credits).with("Reward Purchase", @student_account_name, @credit_manager.main_account_name, @amount).once
          @credit_manager.transfer_credits_for_reward_purchase(@student, @amount)
        end
      end
    end
  end
end
