require 'test_helper'

describe PlutusAmountDecorator do
  it "displays debit amounts properly" do
    @plutus_amount = Plutus::DebitAmount.new amount: BigDecimal('10')
    dec = PlutusAmountDecorator.new(@plutus_amount) 
    dec.amount.must_equal '$10.00'
  end
  it "displays credit amounts properly" do
    @plutus_amount = Plutus::CreditAmount.new amount: BigDecimal('10')
    dec = PlutusAmountDecorator.new(@plutus_amount) 
    dec.amount.must_equal '-$10.00'
  end
end
