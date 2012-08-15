# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).


State.create([{ :name => "Alabama", :abbr => "AL"},
              { :name => "Alaska", :abbr => "AK"},
              { :name => "Arizona", :abbr => "AZ"},
              { :name => "Arkansas", :abbr => "AR"},
              { :name => "California", :abbr => "CA"},
              { :name => "Colorado", :abbr => "CO"},
              { :name => "Connecticut", :abbr => "CT"},
              { :name => "Delaware", :abbr => "DE"},
              { :name => "District of Columbia", :abbr => "DC"},
              { :name => "Florida", :abbr => "FL"},
              { :name => "Georgia", :abbr => "GA"},
              { :name => "Hawaii", :abbr => "HI"},
              { :name => "Idaho", :abbr => "ID"},
              { :name => "Illinois", :abbr => "IL"},
              { :name => "Indiana", :abbr => "IN"},
              { :name => "Iowa", :abbr => "IA"},
              { :name => "Kansas", :abbr => "KS"},
              { :name => "Kentucky", :abbr => "KY"},
              { :name => "Louisiana", :abbr => "LA"},
              { :name => "Maine", :abbr => "ME"},
              { :name => "Montana", :abbr => "MT"},
              { :name => "Nebraska", :abbr => "NE"},
              { :name => "Nevada", :abbr => "NV"},
              { :name => "New Hampshire", :abbr => "NH"},
              { :name => "New Jersey", :abbr => "NJ"},
              { :name => "New Mexico", :abbr => "NM"},
              { :name => "New York", :abbr => "NY"},
              { :name => "North Carolina", :abbr => "NC"},
              { :name => "North Dakota", :abbr => "ND"},
              { :name => "Ohio", :abbr => "OH"},
              { :name => "Oklahoma", :abbr => "OK"},
              { :name => "Oregon", :abbr => "OR"},
              { :name => "Maryland", :abbr => "MD"},
              { :name => "Massachusetts", :abbr => "MA"},
              { :name => "Michigan", :abbr => "MI"},
              { :name => "Minnesota", :abbr => "MN"},
              { :name => "Mississippi", :abbr => "MS"},
              { :name => "Missouri", :abbr => "MO"},
              { :name => "Pennsylvania", :abbr => "PA"},
              { :name => "Rhode Island", :abbr => "RI"},
              { :name => "South Carolina", :abbr => "SC"},
              { :name => "South Dakota", :abbr => "SD"},
              { :name => "Tennessee", :abbr => "TN"},
              { :name => "Texas", :abbr => "TX"},
              { :name => "Utah", :abbr => "UT"},
              { :name => "Vermont", :abbr => "VT"},
              { :name => "Virginia", :abbr => "VA"},
              { :name => "Washington", :abbr => "WA"},
              { :name => "West Virginia", :abbr => "WV"},
              { :name => "Wisconsin", :abbr => "WI"},
              { :name => "Wyoming", :abbr => "WY"}
             ])

states = {
"Alabama" => "AL",
"Alaska" => "AK",
"Arizona" => "AZ",
"Arkansas" => "AR",
"California" => "CA",
"Colorado" => "CO",
"Connecticut" => "CT",
"Delaware" => "DE",
"District of Columbia" => "DC",
"Florida" => "FL",
"Georgia" => "GA",
"Hawaii" => "HI",
"Idaho" => "ID",
"Illinois" => "IL",
"Indiana" => "IN",
"Iowa" => "IA",
"Kansas" => "KS",
"Kentucky" => "KY",
"Louisiana" => "LA",
"Maine" => "ME",
"Montana" => "MT",
"Nebraska" => "NE",
"Nevada" => "NV",
"New Hampshire" => "NH",
"New Jersey" => "NJ",
"New Mexico" => "NM",
"New York" => "NY",
"North Carolina" => "NC",
"North Dakota" => "ND",
"Ohio" => "OH",
"Oklahoma" => "OK",
"Oregon" => "OR",
"Maryland" => "MD",
"Massachusetts" => "MA",
"Michigan" => "MI",
"Minnesota" => "MN",
"Mississippi" => "MS",
"Missouri" => "MO",
"Pennsylvania" => "PA",
"Rhode Island" => "RI",
"South Carolina" => "SC",
"South Dakota" => "SD",
"Tennessee" => "TN",
"Texas" => "TX",
"Utah" => "UT",
"Vermont" => "VT",
"Virginia" => "VA",
"Washington" => "WA",
"West Virginia" => "WV",
"Wisconsin" => "WI",
"Wyoming" => "WY"
}

states.each do |state|
#  State.create name: state.first, abbr: state.last
end

Spree::Core::Engine.load_seed if defined?(Spree::Core)
Spree::Auth::Engine.load_seed if defined?(Spree::Auth)

begin
  f = Filter.find(1)
rescue
  if Filter.all.count < 1
    f = Filter.new(:minimum_grade => 0, :maximum_grade => 12)
    #  f.id = 0
    f.school_filter_links << SchoolFilterLink.create(:school_id => nil)
    f.classroom_filter_links << ClassroomFilterLink.create(:classroom_id => nil)
    f.state_filter_links << StateFilterLink.create(:state_id => nil)
    f.person_class_filter_links << PersonClassFilterLink.create(:person_class => nil)
    f.save
  end
end

# Get rid of the core spree payment methods and just add one for LE Bucks
Spree::PaymentMethod.delete_all
[:development, :production].each do |environment|
  pm = Spree::PaymentMethod.new(name: "LearningEarnings")
  pm.type = "Spree::Gateway::LearningEarnings"
  pm.environment = environment
  pm.active = true
  pm.save
end

existing = Spree::ShippingMethod.find_by_name('In Classroom')
if existing.nil?
  sc = Spree::ShippingCategory.new(name: 'In Classroom')
  sm = Spree::ShippingMethod.new(name: 'In Classroom', zone_id: 2, match_none: false, match_one: false)
  c = Spree::Calculator::FlatRate.new()
  sm.calculator = c
  sm.shipping_category = sc
  sm.save
end

Dir.foreach('public/avatars/football/college') do |item|
  next if item.match(/^\./)
  a = Avatar.new
  a.image = Rails.root.join("public/avatars/football/college/#{item}")
  a.description = item
  a.save
end


# Prepare some seed data for use in development
if Rails.env.development? || Rails.env.production?
  # Get our factories
  require 'factory_girl'
  require Rails.root.join('test', 'support', 'factories.rb')

  # Prepare a creditmanager instance
  @credit_manager = CreditManager.new

  # Create the main liability account for LE
  Plutus::Liability.create(name: @credit_manager.main_account_name)

  # Prepare a school
  @school = FactoryGirl.create(:school)
  # Issue some credits to the school
  @school_credits = 20_000
  @credit_manager.issue_credits_to_school(@school, @school_credits)

  # Create a teacher
  @teacher = FactoryGirl.create(:teacher)
  @teacher_link = FactoryGirl.create(:person_school_link, school: @school, person: @teacher)

  # Give the teacher some credits
  @teacher_credits = 5000
  @credit_manager.issue_credits_to_teacher(@school, @teacher, @teacher_credits)

  # Give the school some students
  @student1 = FactoryGirl.create(:student)
  @link1 = FactoryGirl.create(:person_school_link, school: @school, person: @student1)
  @student2 = FactoryGirl.create(:student)
  @link2 = FactoryGirl.create(:person_school_link, school: @school, person: @student2)

  # Associate spree users with thoses students
  @user1 = FactoryGirl.create(:spree_user, person: @student1, email: 'student1@example.com')
  @user2 = FactoryGirl.create(:spree_user, person: @student2, email: 'student2@example.com')

  # Give a student some credits
  @student_credits = 100
  @credit_manager.issue_credits_to_student(@school, @teacher, @student1, @student_credits)
end
