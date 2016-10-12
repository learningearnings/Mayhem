require 'csv'
namespace :credits_report do
  desc "Generate the CSV that contains all credits deposited after their expiration date."
  task :expired => :environment do
    otu_created_at = "2016-01-01 00:00:00.000000"
    transactions = OtuCode.joins(person_school_link: [:school, :person]).where("otu_codes.redeemed_at > otu_codes.expires_at AND otu_codes.created_at >= ?", otu_created_at).order("schools.name ASC, people.first_name ASC, otu_codes.created_at DESC")
    file_name = "expired_credit_deposited.csv"
    CSV.open("/home/deployer/#{file_name}", "wb") do |csv|
      csv << ["Otu Code Id","School Name", "Teacher Name", "Student Name", "Points", "Created At", "Redeemed At", "Expires At"]
      transactions.each do |t|
        csv << [t.id,t.school.name,t.teacher.name, t.student.name, t.points, t.created_at, t.redeemed_at, t.expires_at]
      end
      puts "Adding Record to CSV"
    end 
    puts "Created expired_credit_deposited.csv file in public folder."
  end

  ##Save newly created reward delivery ids to csv file into the public folder.
  def export_to_csv(school_name, teacher_name,student_name,points,created_at, redeemed_at, expires_at)
    file_name = "expired_credit_deposited.csv"
    CSV.open("/home/deployer/reward_deliveries_csv/#{file_name}", "wb") do |csv|
      csv << ["School Name", "Teacher Name", "Student Name", "Points", "Created At", "Redeemed At", "Expires At"]
   		csv << [school_name, teacher_name,student_name,points,created_at, redeemed_at, expires_at]
   		puts "Adding Record to CSV"
    end	
  end
end

