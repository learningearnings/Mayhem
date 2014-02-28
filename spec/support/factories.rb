FactoryGirl.define do
  factory :person do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }

    factory :teacher, class: Teacher do
      sequence(:first_name) {|n| "Teacher #{n}"}
      sequence(:username) {|n| "user #{n}"}
      dob 25.years.ago
      grade 9
    end
  end

  factory :spree_user, class: Spree::User do
    email { Faker::Internet.email }
    username { Faker::Internet.user_name }
    password "123456"
    password_confirmation "123456"
  end
end
