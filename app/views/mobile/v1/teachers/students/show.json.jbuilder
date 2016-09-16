json.(@student, :id, :first_name, :last_name, :full_name, :grade, :gender)

json.avatar_url @student.avatar.try(:image).try(:url)

json.classrooms @student.classrooms do |classroom|
  json.(classroom, :id, :name)
end

json.checking_history @checking_history.each do |amount|
    json.id amount.transaction_id
    json.description amount.transaction.description
    json.type (amount.type.to_s == "Plutus::DebitAmount")?"Debit":"Credit"
    json.amount amount.amount.to_i
end	

json.username @student.user.username
json.email @student.user.email
