# lib/tasks/import.rake
require 'importers/db_schools_importer'

namespace :import do
  desc 'import the legacy schools data'
  task :schools => :environment do
    osi = OldSchoolImporter.new
    OldSchool.connection.execute("update tbl_users set usercreated = '20100701' where date(usercreated) = '20100010'")
    OldSchool.connection.execute("update tbl_users set usercreated = '20100701' where date(usercreated) = '20100011'")
    if Rails.env.development?
      puts "Development environment detected ---- Resetting..."
      OldSchool.connection.execute("update tbl_schools set ad_profile = 0 where ad_profile = 20")
      OldSchool.school_subset.each do |s|
        s.old_users.each do |u|
          p = Person.find_by_legacy_user_id(u.id)
          if p
            p.person_school_links.each do |l| l.destroy end
            p.user.destroy
            p.locker.destroy
             if p.respond_to? checking_account
              p.checking_account.destroy
            end
            if p.respond_to? savings_account
              p.savings_account.destroy
            end
            if p.respond_to? hold_account
              p.hold_account.destroy
            end
            if p.respond_to? checking_account
              p.checking_account.destroy
            end
            if p.respond_to? main_account
              p.main_account.destroy
            end
            if p.respond_to? unredeemed_account
              p.unredeemed_account.destroy
            end
            if p.respond_to? undeposited_account
              p.undeposited_account.destroy
            end
            p.destroy
          end
        end
        s.ad_profile = 1
        s.save
        ns = School.find_by_ad_profile(s.id)
        if ns
          ns.destroy
        end
      end
    end
    puts "---> Importing Schools"
    OldSchool.school_subset.order('schoolID asc').all.each do |s|
      ActiveRecord::Base.transaction do
        ns = osi.import_school(s)
        puts ns.id.to_s + ' ' + ns.name + "  le SchoolID-#{s.schoolID} #{s.old_users.count} Users"
        osi.import_users(ns,s)
        s.ad_profile = 20
        s.save
      end
    end
#    osi.import_classrooms(ns,s)
  end
end
