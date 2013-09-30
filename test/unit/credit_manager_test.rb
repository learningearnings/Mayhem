require 'test_helper'
require_relative '../../app/models/credit_manager'

describe CreditManager do
  before do
    @transaction_class = mock "Plutus::Transaction"
    @account_class = mock "Plutus::Account"
    @main_account = mock "main account"
    @game_account = mock "game account"
    @account_class.stubs(:find_by_name).with("MAIN_ACCOUNT").returns(@main_account)
    @account_class.stubs(:find_by_name).with("GAME_ACCOUNT").returns(@game_account)
    @credit_manager = CreditManager.new(transaction_class: @transaction_class, account_class: @account_class)
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
      commercial_document: nil,
      debits:      [{ account: @account2, amount: @amount }],
      credits:     [{ account: @account1, amount: @amount }]
    }).returns(@mock_transaction)
    @mock_transaction.expects(:save).once
    @credit_manager.transfer_credits(@description, @account1, @account2, @amount)
  end

  describe "dealing with a school" do
    before do
      @school_account = mock("school account")
      @school = mock "school"
    end

    it "issues credits to a school" do
      @school.expects(:main_account).returns(@school_account)
      @amount = BigDecimal("500.00")
      @credit_manager.expects(:transfer_credits).with("Issue Credits to School", @credit_manager.main_account, @school_account, @amount).once
      @credit_manager.issue_credits_to_school(@school, @amount)
    end

    it "revokes credits from a school" do
      @school.expects(:main_account).returns(@school_account)
      @amount = BigDecimal("500.00")
      @credit_manager.expects(:transfer_credits).with("Revoke Credits for School", @school_account, @credit_manager.main_account, @amount).once
      @credit_manager.revoke_credits_for_school(@school, @amount)
    end

    describe "dealing with a teacher" do
      before do
        @teacher_account = mock "teacher account"
        @teacher = mock "teacher"
      end

      it "issues credits to a teacher" do
        @school.expects(:main_account).returns(@school_account)
        @teacher.expects(:main_account).with(@school).returns(@teacher_account)
        @amount = BigDecimal("500.00")
        @credit_manager.expects(:transfer_credits).with("Issue Credits to Teacher", @school_account, @teacher_account, @amount).once
        @credit_manager.issue_credits_to_teacher(@school, @teacher, @amount)
      end

      describe "dealing with a student" do
        before do
          @student_account = mock "student account"
          @student = mock "student"
          @student.expects(:checking_account).returns(@student_account)
        end

        it "issues ecredits to a student" do
          @amount = BigDecimal("500.00")
          @teacher.expects(:undeposited_account).with(@school).returns(@teacher_account)
          @credit_manager.expects(:transfer_credits).with("Issue Credits to Student", @teacher_account, @student_account, @amount).once
          @credit_manager.issue_ecredits_to_student(@school, @teacher, @student, @amount)
        end

        it "issues game credits to a student" do
          @game_account = mock "game account"
          @amount = BigDecimal("500.00")
          game_string = "Food Fight"
          @credit_manager.expects(:game_account).returns(@game_account)
          @credit_manager.expects(:transfer_credits).with("Credits Earned for #{game_string}", @game_account, @student_account, @amount).once
          @credit_manager.issue_game_credits_to_student(game_string, @student, @amount)
        end

        it "issues print credits to a student" do
          @amount = BigDecimal("500.00")
          @teacher.expects(:unredeemed_account).with(@school).returns(@teacher_account)
          @credit_manager.expects(:transfer_credits).with("Issue Credits to Student", @teacher_account, @student_account, @amount).once
          @credit_manager.issue_print_credits_to_student(@school, @teacher, @student, @amount)
        end

        it "transfers credits from a student for reward purchase" do
          @student.expects(:balance).returns(BigDecimal('1000.00'))
          @amount = BigDecimal("500.00")
          @credit_manager.expects(:transfer_credits).with("Reward Purchase", @student_account, @credit_manager.main_account, @amount,nil).once
          @credit_manager.transfer_credits_for_reward_purchase(@student, @amount)
        end
      end
    end
  end

  describe "transferring credits from/to checking/savings" do
    before do
      @student = mock "student"
      @student_checking_account = mock "checking"
      @student_savings_account = mock "savings"
      @student.expects(:checking_account).returns(@student_checking_account)
      @student.expects(:savings_account).returns(@student_savings_account)
      @amount = BigDecimal('100.00')
    end

    it "responds to #transfer_credits_from_checking_to_savings" do
      @student.expects(:checking_balance).returns(@amount)
      @credit_manager.expects(:transfer_credits).with("Transfer from Checking to Savings", @student_checking_account, @student_savings_account, @amount).once
      @credit_manager.transfer_credits_from_checking_to_savings @student, @amount
    end

    it "responds to #transfer_credits_from_savings_to_checking" do
      @student.expects(:savings_balance).returns(@amount)
      @credit_manager.expects(:transfer_credits).with("Transfer from Savings to Checking", @student_savings_account, @student_checking_account, @amount).once
      @credit_manager.transfer_credits_from_savings_to_checking @student, @amount
    end
  end
end
