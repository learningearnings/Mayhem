# SCRIPT TO ZERO OUT CHECKING AND SAVINGS BALANCES FOR STUDENTS
# OUTPUTS A CVS WITH PREVIOUS BALANCES FOR POSTERITY
# J. F. Drake = 1604
# Lacey's = 1628
# West Morgan Middle School = 1636
# Eva school = 1625

s = School.find(1636)
cm = CreditManager.new
student_count = s.students.count
Rails.env.development? ? file_prefix = "/Users/jimmybnsn/Downloads/" : file_prefix = "/home/deployer/"
CSV.open("#{file_prefix}-#{s.name.parameterize.underscore}-#{Time.zone.now.strftime("%m_%d")}-OUTPUT.csv", "wb") do |out_csv|
  out_csv << ["school_id","school_name","student_id","student_last_name","old_cbalance","new_cbalance","old_sbalance","new_sbalance"]
  s.students.each do |student|
    cbalance = student.checking_balance.to_s
    sbalance = student.savings_balance.to_s
    if cbalance != 0
      cm.transfer_credits("Reset Account for new school year", student.checking_account, s.main_account, cbalance)
    end
    if sbalance !=0
      cm.transfer_credits("Reset Account for new school year", student.savings_account, s.main_account, sbalance)
    end
    out_csv << ["#{s.id}","#{s.name}","#{student.id}","#{student.last_name}","#{cbalance}","#{student.checking_balance.to_s}","#{sbalance}","#{student.savings_balance.to_s}"]
  end
end