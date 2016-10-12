require 'csv'
namespace :duplicate_persons do
  desc "Generate the CSV that contains all the duplicate persons with user information and school."
  task :find_them_all => :environment do
    file_name = "duplicate_persons.csv"
    results = ActiveRecord::Base.connection.execute("SELECT id, spree_users.username FROM spree_users INNER JOIN (SELECT username FROM  spree_users GROUP BY username HAVING COUNT(id) > 1) dup ON spree_users.username = dup.username")
    CSV.open("/home/deployer/#{file_name}", "wb") do |csv|
      csv << ["Person Id","First Name", "Last Name", "User Id", "Username", "Type"]
      results.each do |r|
        puts "========================================="
        user = Spree::User.find(r["id"])
        person = user.try(:person)
        csv << [person.try(:id),person.try(:first_name),person.try(:last_name), user.id,user.username, person.try(:type)]
      end
      puts "Adding Record to CSV"
    end 
    puts "Created duplicate_persons.csv file in public folder."
  end
end

