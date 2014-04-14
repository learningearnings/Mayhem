FactoryGirl.define do
  factory :person do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    association :user, factory: :spree_user

    factory :teacher, class: Teacher do
      dob 25.years.ago
      grade 9
    end

    factory :student, class: Student do
      dob nil
      grade 9
    end
  end

  factory :spree_user, class: Spree::User do
    email { Faker::Internet.email }
    username { Faker::Internet.user_name }
    password "123456"
    password_confirmation "123456"
  end

  factory :school do
    name { Faker::Company.name }
    min_grade 1
    max_grade 12
    school_phone { Faker::PhoneNumber.phone_number }
    school_type_id 1
    school_mail_to { Faker::Internet.email }
    mascot_name { Faker::Lorem.word }
    school_demo false
    status "active"
    logo_name "Logo"
    logo_uid "2323"
    timezone "Central Time (US & Canada)"
    gmt_offset "6.0"
    distribution_model "Delivery"
    address1 { Faker::Address.street_address }
    address2 { Faker::Address.secondary_address }
    city { Faker::Address.city }
    state_id {FactoryGirl.create(:state).id}
    zip { Faker::Address.zip_code }
    ad_profile 1
  end

  factory :address do
    line1 "529 Beacon Parkway"
    city "Birmingham"
    zip "35209"
    state_id {FactoryGirl.create(:state).id}
  end

  factory :person_school_link do
    person
    school
  end

  factory :person_school_classroom_link do
    person_school_link
    classroom
  end

  factory :state do
    abbr { Faker::Address.state_abbr }
    name { Faker::Address.state }
  end

  factory :classroom do
    sequence(:name) {|n| "Test Classroom #{n}"}
    school
  end

  factory :spree_product, class: Spree::Product do
    name "Some Product"
    available_on "2012-01-01"
    permalink "some-product"
    count_on_hand 20
    price 10
  end

  factory :poll do
    title { Faker::Lorem.word }
    question { Faker::Lorem.word }
    min_grade 1
    max_grade 12
  end
end
