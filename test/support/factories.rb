FactoryGirl.define do
  factory :person do
    first_name "Testy"
    last_name "McTesterson"
    association :user, factory: :spree_user

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
      sequence(:username) {|n| "user #{n}"}
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

  factory :display_name do
    sequence(:display_name) { |n| "display_name#{n}" }
    user
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

  factory :message do
    association :from, factory: :person
    association :to,   factory: :person
    subject "Test Message"
    body    "Test Body"
    category "friend"

    factory :school_message do
      category "school"
    end

    factory :system_message do
      category "system"
    end

    factory :teacher_message do
      category "teacher"
    end

    factory :friend_mesage do
      category "friend"
    end
  end

  factory :reward_delivery do
    association :from, factory: :person
    association :to,   factory: :person
    association :reward, factory: :spree_product
    status "pending"
    factory :pending_reward_delivery do
      status "pending"
    end
    factory :delivered_reward_delivery do
      status "delivered"
    end
  end

  factory :spree_product, class: Spree::Product do
    name "Some Product"
    available_on "2012-01-01"
    permalink "some-product"
    count_on_hand 20
    price BigDecimal('10')
  end

  factory :spree_store, class: Spree::Store do
    name  "Test Store"
    code  "123"
    email "foo@example.com"
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
    sequence(:email) {|n| "foo#{n}@bar.com"}
    sequence(:username) {|n| "foo#{n}"}
    password "123456"
    password_confirmation "123456"
    #person
  end

  factory :question, class: Games::Question do
    grade 1
    body "Foo bar baz witchity?"
    factory :food_fight_question do
      game_type "FoodFight"
    end
  end

  factory :answer, class: Games::Answer do
    body "Answer!!!"
    factory :food_fight_answer do
      game_type "FoodFight"
    end
  end

  factory :game_question_answer, class: Games::QuestionAnswer do
    question
    answer
    correct false
  end

  factory :sticker do
    image { Rails.root.join("public/avatars/football/college/Alabama_Crimson_Tide_Roll_Tide.gif") }
  end

  factory :avatar do
    image { open('http://learningearnings.com/images/rewardimage/LE_Tote.jpg') }
#    image { Rails.root.join("public/avatars/football/college/Alabama_Crimson_Tide_Roll_Tide.gif") }
    sequence(:description) {|n| "Avatar Description - #{n}"}
    sequence(:image_name) {|n| "Avatar image_name #{n}"}
  end


  factory :locker_sticker_link do
    locker
    sticker
    x 1
    y 1
  end

  factory :locker do
    person
  end

  factory :otu_code do
    code            "test"
    person_school_link
    student
    points          BigDecimal("5")
    expires_at      Time.now + 5.days
  end
end
