# lib/tasks/import.rake

namespace :import do
  desc 'reset the import'
  task :reset => :environment do
    require 'importers/db_schools_importer'
    osi = OldSchoolImporter.new
    osi.reset
  end

  desc 'import the legacy schools\' data'
  task :schools => :environment do
    require 'importers/db_schools_importer'
    osi = OldSchoolImporter.new
    if Rails.env.development? && false
      puts "Development environment detected ---- Resetting..."
      osi.reset
    end
    puts "---> Importing Schools"
    osi.importable_schools.all.each do |s|
      ActiveRecord::Base.transaction do
        ns = osi.import_school(s)
        puts ns.id.to_s + ' ' + ns.name + "  le SchoolID-#{s.schoolID} #{s.old_users.count} Users"
        osi.import_users(ns,s)
        s.ad_profile = 20
        s.save
      end
    end

    imported_points = 0
    osi.imported_schools.each do |ns|
      s = OldSchool.find(ns.ad_profile)
      puts "-------------------Classrooms for #{ns.name} #{ns.id}"
      if s
        ActiveRecord::Base.transaction do
          osi.import_classrooms(ns,s)
          s.old_users.each do |old_student|
            imported_points = imported_points + osi.import_points(s,old_student,ns)
          end
        end
      else
        puts "Could not find old school for #{ns.name}"
      end
      puts "Imported #{imported_points} credits for #{ns.name}"
      imported_points = 0
    end
  end
end
