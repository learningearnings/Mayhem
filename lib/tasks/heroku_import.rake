# lib/tasks/import.rake

namespace :heroku_import do
  desc 'import the data'
  task :run => :environment do
    Importers::Le.new("schools.csv", "users.csv", "classrooms.csv", "classroom_details.csv", "points.csv").call
  end
end


