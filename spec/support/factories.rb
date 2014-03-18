FactoryGirl.define do
  factory :person do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }

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
    if State.where(id: 1).present?
      state_id 1
    else
      state_id {FactoryGirl.create(:state).id}
    end
    zip { Faker::AddressUS.zip_code }
    ad_profile 1
  end

  factory :state do
    abbr 'AL'
    name 'Alabama'
  end

  factory :food_fight_match do
    active true
  end

  factory :food_fight_player do
    person_id FactoryGirl.build(:person)
  end


end
