# lib/tasks/import.rake

namespace :import do
  desc 'reset the import'
  task :reset => :environment do
    require 'importers/db_schools_importer'
    osi = OldSchoolImporter.new
    osi.reset
  end

  desc 'Fixup MySQL data "problems"'
  task :fixup => :environment do
    require 'importers/db_schools_importer'
    osi = OldSchoolImporter.new
    osi.fixup
  end



  desc 'import the legacy schools\' data'
  task :schools, [:school_in] => :environment do |tsk, _school_in|
    require 'importers/db_schools_importer'
    schools = _school_in[:school_in].split('-') if !_school_in[:school_in].blank?
    schools = nil if _school_in[:school_in].blank?
    puts "_school_in is #{_school_in} and schools was #{schools}"
    osi = OldSchoolImporter.new
    if Rails.env.development? && false
      puts "Development environment detected ---- Resetting..."
      osi.reset
    end
    puts "---> Importing Schools"
    osi.importable_schools(schools).each do |s|
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
  end

  task :classrooms, [:school_in] => :environment do |tsk, _school_in|
    require 'importers/db_schools_importer'
    school = _school_in[:school_in] if !_school_in[:school_in].blank?
    school = nil if _school_in[:school_in].blank?
    puts "_school_in is #{_school_in} and school was #{school}"
    imported_purchases = imported_points = 0
    osi = OldSchoolImporter.new
    osi.importable_schools(school).where('ad_profile > 19').all.each do |s|
      ns = School.find_by_legacy_school_id(s.schoolID)
      puts "-------------------Classrooms for #{ns.name} #{ns.id}"
      if s && ns
        osi.reset_school_cache
        osi.import_classrooms(ns,s)
      else
        puts "Could not find old school for #{ns.name}"
      end
    end
  end


  task :transactions, [:school_in] => :environment do |tsk, _school_in|
    require 'importers/db_schools_importer'
    school = _school_in[:school_in] if !_school_in[:school_in].blank?
    school = nil if _school_in[:school_in].blank?
    puts "_school_in is #{_school_in} and school was #{school}"
    imported_purchases = imported_points = 0
    osi = OldSchoolImporter.new
    osi.importable_schools(school).where('ad_profile > 19').all.each do |s|
      ns = School.find_by_legacy_school_id(s.schoolID)
      if s && ns
        osi.reset_school_cache
        rowcount = 0;
        rowspersec = 0;
        start_time = Time.now
        rowcount += osi.import_buck_batches(s,ns)
        s.old_users.each do |old_student|
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
  end

  # run this after everything else
  task :quantities => :environment do
    osi = OldSchoolImporter.new
    osi.update_wholesale_quantities
  end


end
