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
    @transaction_class.expects(:build).with({
      description: "Credit Transfer",
      debits:      [{ account: @account1, amount: @amount }],
      credits:     [{ account: @account2, amount: @amount }]
    }).returns(@mock_transaction)
    @mock_transaction.expects(:save).once
    @credit_manager.transfer_credits(@account1, @account2, @amount)
  end

  describe "dealing with a school" do
    before do
      @school_account_name = "SCHOOLfoo"
      @school = mock "school"
      @school.expects(:account_name).returns(@school_account_name)
    end

    it "issues credits to a school" do
      @amount = BigDecimal("500.00")
      @credit_manager.expects(:transfer_credits).with(@credit_manager.main_account_name, @school_account_name, @amount).once
      @credit_manager.issue_credits_to_school(@school, @amount)
    end

    it "revokes credits from a school" do
      @amount = BigDecimal("500.00")
      @credit_manager.expects(:transfer_credits).with(@school_account_name, @credit_manager.main_account_name, @amount).once
      @credit_manager.revoke_credits_for_school(@school, @amount)
    end
  end
end
