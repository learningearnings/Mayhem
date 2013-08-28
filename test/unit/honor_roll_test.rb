require 'test_helper'
require 'active_support/all'

require_relative '../../app/models/honor_roll'

module Plutus
  class Account; end
  class Transaction; end
end
module Spree
  class Product; end
end

describe HonorRoll do
  let(:date1){ 7.days.ago }
  let(:date2){ 0.days.ago }
  let(:school){ mock "School" }
  subject { HonorRoll.new(school, date1, date2) }

  ### PRIVATE METHOD TEST DRIVING
  ### REMOVE LATER
  #it 'gets the number of charity purchases in the last 7 days' do
    #fail # This is fine...
  #end
  #

  it 'is initialized with a school and a time range' do
    subject.school.must_equal(school)
    subject.start_date.must_equal(date1)
    subject.end_date.must_equal(date2)
  end

  describe 'charity calculations' do
    let(:tran1){ mock "Transaction 1" }
    let(:tran2){ mock "Transaction 2" }
    let(:tran3){ mock "Transaction 3" }
    let(:amount1){ mock "Amount 1" }
    let(:amount2){ mock "Amount 2" }
    let(:amount3){ mock "Amount 3" }
    let(:account1) { "Account 1" }
    let(:account2) { "Account 2" }
    let(:transactions_relation){ Object.new }
    let(:mock_transactions) { [tran1, tran2, tran3] }

    before do
      Spree::Product.stubs(:with_property_value)
      Plutus::Transaction.stubs(:with_main_account).returns(transactions_relation)
      PersonAccountLink = mock "PersonAccountLink"
      person_account_link_relation = mock 'PersonAccountLink relation'
      PersonAccountLink.stubs(:includes).returns(person_account_link_relation)
      person_account_link_relation.stubs(:for_school).returns(person_account_link_relation)
      person_account_link_relation.stubs(:map).returns([account1, account2])
      transactions_relation.stubs(:with_spree_products).returns(transactions_relation)
      transactions_relation.stubs(:order).returns(transactions_relation)
      transactions_relation.stubs(:where).returns(transactions_relation)
      transactions_relation.stubs(:for_accounts).returns(transactions_relation)
      transactions_relation.stubs(:merge).returns(mock_transactions)
      amount1.stubs(:account_id).returns(1)
      amount2.stubs(:account_id).returns(2)
      amount3.stubs(:account_id).returns(2)
      amount1.stubs(:amount).returns(BigDecimal('1.50'))
      amount2.stubs(:amount).returns(BigDecimal('2.50'))
      amount3.stubs(:amount).returns(BigDecimal('1.50'))
      tran1.stubs(:credit_amounts).returns([amount1])
      tran2.stubs(:credit_amounts).returns([amount2])
      tran3.stubs(:credit_amounts).returns([amount3])
    end

    it "groups account_ids and sums amounts" do
      subject.send(:charity_purchases_per_account, 3).must_equal({
        1 => BigDecimal('1.50'),
        2 => BigDecimal('4.00')
      })
    end

    it "returns transactions between the two dates" do
      transactions_relation.expects(:where).with('plutus_transactions.created_at BETWEEN ? AND ?', date1, date2).returns(transactions_relation)
      subject.send(:charity_purchases_per_account, 3)
    end

    describe "grouped" do
      let(:person1){ mock "Person 1" }
      let(:person2){ mock "Person 2" }

      before do
        person_account_link1 = mock "Person Account Link 1"
        person_account_link2 = mock "Person Account Link 2"
        account1.stubs(:person_account_link).returns(person_account_link1)
        account2.stubs(:person_account_link).returns(person_account_link2)
        person_account_link1.stubs(:person).returns(person1)
        person_account_link2.stubs(:person).returns(person2)
        Plutus::Account.stubs(:find).with(1).returns(account1)
        Plutus::Account.stubs(:find).with(2).returns(account2)
      end

      it "groups people and sums amounts" do
        subject.charity_purchases_per_person.must_equal({
          person1 => BigDecimal('1.50'),
          person2 => BigDecimal('4.00')
        })
      end

      it "returns the top n people" do
        expected_charity_purchases = {
          person2 => BigDecimal('4.00')
        }
        subject.charity_purchases_per_person(1).must_equal expected_charity_purchases
      end
    end
  end

  describe 'most credits deposited calculations' do
  end
end
