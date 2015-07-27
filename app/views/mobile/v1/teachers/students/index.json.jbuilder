json.array! @students do |student|
  json.(student, :id, :first_name, :last_name, :grade, :gender, :classrooms)
  json.username student.user.username
  json.email student.user.email
  json.checking_history Plutus::Amount.where(account_id: student.checking_account).order(" id desc ").each do |amount|
    json.id amount.transaction_id
    json.description amount.transaction.description
    json.type (amount.type.to_s == "Plutus::DebitAmount")?"Debit":"Credit"
    json.amount amount.amount.to_i
  end	
end
