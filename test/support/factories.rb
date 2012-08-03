# This will guess the User class
FactoryGirl.define do

  factory :user do
    email "user@example.com"
    password "password"
    confirmation "password"
  end

  factory :person do
    sequence(:first_name) {|n| "Testy #{n}"}
    first_name "Testy"
    last_name "McTesterson"
    dob 15.years.ago
    grade 9

    factory :student, class: Student do
    end

    factory :teacher, class: Teacher do
    end
  end

  factory :person_school_link do
    person
    school
  end

  factory :school do
    sequence(:name) {|n| "Test School #{n}"}
    min_grade 1
    max_grade 12
    school_phone "123-456-7890"
    school_type_id 1
    school_mail_to "school@test.com"
    mascot_name "Bubbles"
    school_demo false
    status "active"
    logo_name "Logo"
    logo_uid "2323"
    timezone "Central"
    gmt_offset "6.0"
    distribution_model "Delivery"
    ad_profile 1
    school_address_id 1
  end

  factory :classroom do
    sequence(:name) {|n| "Test Classroom #{n}"}
  end



  factory :address do
  end
end
