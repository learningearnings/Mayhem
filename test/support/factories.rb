# This will guess the User class
FactoryGirl.define do

  factory :user do
    email "user@example.com"
    password "password"
    confirmation "password"
  end

  factory :person do
    first_name "Testy"
    last_name "McTesterson"

    factory :student, class: Student do
      sequence(:first_name) {|n| "Student #{n}"}
      dob nil
      grade 9
    end

    factory :school_admin, class: SchoolAdmin do
      sequence(:first_name) {|n| "SchoolAdmin #{n}"}
      dob 25.years.ago
      grade 9
    end

    factory :teacher, class: Teacher do
      sequence(:first_name) {|n| "Teacher #{n}"}
      dob 25.years.ago
      grade 9
    end

    factory :le_admin, class: LeAdmin do
      sequence(:first_name) {|n| "LE Admin #{n}"}
      dob 40.years.ago
    end
  end

  factory :person_school_link do
    person
    school
  end

  factory :student_school_link, class: PersonSchoolLink do
    association :person, factory: :student
    school
  end

  factory :school_admin_school_link, class: PersonSchoolLink do
    association :person, factory: :school_admin
    school
  end

  factory :person_school_classroom_link do
    person_school_link
    classroom
  end

  factory :state do
    name {|n| "State #{n}" }
    abbr {|n| "S#{n}" }
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
  end

  factory :classroom do
    sequence(:name) {|n| "Test Classroom #{n}"}
  end

  factory :address do
    state
    line1 "529 Beacon Parkway"
    city "Birmingham"
    zip "35209"
    association :addressable
  end

  factory :spree_user, class: Spree::User do
    email "foo@bar.com"
    password "123456"
    password_confirmation "123456"
    person
  end
end
