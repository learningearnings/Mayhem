class PlutusAmountDecorator < Draper::Base
  decorates :plutus_amount, class: Plutus::Amount

  # NOTE: I really don't understand why these are reversed
  def amount
    case plutus_amount
    when Plutus::DebitAmount
      plutus_amount.amount
    when Plutus::CreditAmount
      -1 * plutus_amount.amount
    end
  end
end
