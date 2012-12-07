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
    schools = _school_in[:school_in].split('-').collect {|s| s.to_i } if !_school_in[:school_in].blank?
    schools = nil if _school_in[:school_in].blank?
    puts "_school_in is #{_school_in} and schools was #{schools}"
    osi = OldSchoolImporter.new
    if Rails.env.development? && false
      puts "Development environment detected ---- Resetting..."
      osi.reset
    end
    dependant_schools = osi.dependant_schools schools
    puts "Dependant Schools are --> " + dependant_schools.join(',')
    schools += dependant_schools
    puts "---> Importing Schools" 
    osi.importable_schools(schools).each do |s|
      next if School.find_by_legacy_school_id(s.id)
      # Claim this school as in progress
      s.with_lock do
        begin
          s.ad_profile = 21
          s.save!
        rescue
          puts "Already processed users for #{s.school}"
          next
        end
      end
      ActiveRecord::Base.transaction do
        ns = osi.import_school(s)
        next if ns.legacy_school_id == s.schoolID
        ns.legacy_school_id = s.schoolID
        ns.save
        puts ns.id.to_s + ' ' + ns.name + "  le SchoolID-#{s.schoolID} #{s.old_users.count} Users"
        osi.import_users(ns,s)
      end
    end
  end

  task :classrooms, [:school_in] => :environment do |tsk, _school_in|
    require 'importers/db_schools_importer'
    schools = _school_in[:school_in].split('-').collect {|s| s.to_i } if !_school_in[:school_in].blank?
    schools = nil if _school_in[:school_in].blank?
    puts "_school_in is #{_school_in} and schools was #{schools}"
    osi = OldSchoolImporter.new
    dependant_schools = osi.dependant_schools schools
    puts "Dependant Schools are --> " + dependant_schools.join(',')
    schools += dependant_schools
    imported_purchases = imported_points = 0
    osi.importable_schools(schools).where(:ad_profile => 21).all.each do |s|
      ns = School.find_by_legacy_school_id(s.schoolID)
      puts "-------------------Classrooms for #{ns.name} #{ns.id}"
      if s && ns
        s.with_lock do
          begin
            s.ad_profile = 22
            s.save!
          rescue
            puts "Already processed classrooms for #{s.school}"
            next
          end
        end
        osi.reset_school_cache
        osi.import_classrooms(ns,s)
      else
        puts "Could not find old school for #{ns.name}"
      end
    end
  end


  task :transactions, [:school_in] => :environment do |tsk, _school_in|
    require 'importers/db_schools_importer'
    schools = _school_in[:school_in].split('-').collect {|s| s.to_i } if !_school_in[:school_in].blank?
    schools = nil if _school_in[:school_in].blank?
    puts "_school_in is #{_school_in} and schools was #{schools}"
    osi = OldSchoolImporter.new
    dependant_schools = osi.dependant_schools schools
    puts "Dependant Schools are --> " + dependant_schools.join(',')
    schools += dependant_schools
    imported_purchases = imported_points = 0
    osi.importable_schools(schools).where(:ad_profile => 22).all.each do |s|
      ns = School.find_by_legacy_school_id(s.schoolID)
      if s && ns
        s.with_lock do
          begin
            s.ad_profile = 23
            s.save!
          rescue
            puts "Already processed transactions for #{s.school}"
            next
          end
        end
        osi.reset_school_cache
        rowcount = 0;
        rowspersec = 0;
        start_time = Time.now
        rowcount += osi.import_buck_batches(s,ns)
        s.old_users.each do |old_student|
#          ActiveRecord::Base.transaction do
            points_and_rewards = osi.import_points(s,old_student,ns,rowspersec)
            imported_points = imported_points + points_and_rewards[0]
            imported_purchases = imported_purchases + points_and_rewards[1]
            rowcount += ((points_and_rewards[2]||0) + (points_and_rewards[3]||0))
#          end
          end_time = Time.now
          elapsed_time = end_time - start_time
          rowspersec = ((rowcount) / elapsed_time).round(2)
        end
        osi.make_school_and_teacher_entries ns
        osi.update_quantities(s,ns)
        osi.import_teacher_balances s,ns
      else
        puts "Could not find old school for #{s.school}"
      end
      puts "   --> Imported #{imported_points} credits for #{ns.name}"
      puts "   --> Imported #{imported_purchases} purchases for #{ns.name}"
      imported_purchases = imported_points = 0
    end
  end

  # run these after everything else
  task :quantities => :environment do
    require 'importers/db_schools_importer'
    osi = OldSchoolImporter.new
    osi.update_wholesale_quantities
  end

  task :local_reward_categories => :environment do
    require 'importers/db_schools_importer'
    osi = OldSchoolImporter.new
    osi.import_local_reward_categories
  end



end
