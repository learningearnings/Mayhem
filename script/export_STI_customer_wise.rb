# custom export of teachers + school admins outside of Alabama to import into their CustomerWise app
CSV.open("/Users/jimmybnsn/Downloads/LE_staff_export_customer_wise_#{Date.today.to_s}.csv", "wb") do |out_csv|
  out_csv << ["School","City","State","First","Last","Email","Type","Synced?"]
  Teacher.recently_logged_in.each do |staff|
    staff.sti_id ? synced = "yes" : synced = "no"
    unless staff.school.state.id == 1 
      out_csv << ["#{staff.school.name}","#{staff.school.address1}","#{staff.school.city}","#{staff.school.state.abbr}","#{staff.first_name}","#{staff.last_name}","#{staff.user.email}","#{staff.type}","#{synced}"] 
    end
  end  
end