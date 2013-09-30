#! /usr/bin/env /home/dwilkins/source/Mayhem/script/rails runner
PersonAccountLink.all.each do |pal|
  pal.destroy
end
PersonSchoolLink.all.each do |psl|
  p = psl.person
  s = psl.school
  p.accounts(s).each do |a|
    pal = PersonAccountLink.create(person_school_link_id: psl.id, plutus_account_id: a.id)
    if a == p.main_account(s)
      pal.is_main_account = true
      pal.save
    end
  end
end
