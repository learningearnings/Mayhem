# lib/tasks/import.rake

namespace :import do
  desc 'reset the import'
  task :reset => :environment do
    require 'importers/db_schools_importer'
    osi = OldSchoolImporter.new
    osi.reset
  end

  desc 'import the legacy schools\' data'
  task :schools, [:worker] => :environment do |tsk, w|
    require 'importers/db_schools_importer'
    worker = w[:worker] if !w[:worker].blank?
    worker = nil if w[:worker].blank?
    puts "worker is #{worker} and w was #{w}"
    osi = OldSchoolImporter.new
    if Rails.env.development? && false
      puts "Development environment detected ---- Resetting..."
      osi.reset
    end
    puts "---> Importing Schools"
    osi.importable_schools(worker).all.each do |s|
      ActiveRecord::Base.transaction do
        ns = osi.import_school(s)
        next if ns.legacy_school_id == s.schoolID
        ns.legacy_school_id = s.schoolID
        ns.save
        puts ns.id.to_s + ' ' + ns.name + "  le SchoolID-#{s.schoolID} #{s.old_users.count} Users"
        osi.import_users(ns,s)
        s.ad_profile = 20
        s.save
      end
    end

    imported_purchases = imported_points = 0
    osi.importable_schools(worker).all.each do |s|
      ns = School.find_by_legacy_school_id(s.schoolID)
      puts "-------------------Classrooms for #{ns.name} #{ns.id}"
      if s && ns
        osi.reset_school_cache
        osi.import_classrooms(ns,s)
        rowcount = 0;
        rowspersec = 0;
        start_time = Time.now
        rowcount += osi.import_buck_batches(s,ns)
        s.old_users.each do |old_student|
#          next if !OldPoint.exists?(:userID => old_student.userID)
          ActiveRecord::Base.transaction do
            points_and_rewards = osi.import_points(s,old_student,ns,rowspersec)
            imported_points = imported_points + points_and_rewards[0]
            imported_purchases = imported_purchases + points_and_rewards[1]
            rowcount += ((points_and_rewards[2]||0) + (points_and_rewards[3]||0))
          end
          end_time = Time.now
          elapsed_time = end_time - start_time
          rowspersec = ((rowcount) / elapsed_time).round(2)
        end
        osi.make_school_and_teacher_entries ns
        osi.update_quantities(s,ns)
      else
        puts "Could not find old school for #{ns.name}"
      end
      puts "   --> Imported #{imported_points} credits for #{ns.name}"
      puts "   --> Imported #{imported_purchases} purchases for #{ns.name}"
      imported_purchases = imported_points = 0
    end
    osi.update_wholesale_quantities
  end
end
