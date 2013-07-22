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

  sc = Spree::ShippingCategory.new(name: 'Mailed')
  sm = Spree::ShippingMethod.new(name: 'Shipped To School',zone_id: 2, match_none: false, match_one: false)
  c = Spree::Calculator::FlatRate.new()
  sm.calculator = c
  sm.shipping_category = sc
  sm.save

end

# Generate some avatars
["002.png","003.png","004.png","005.png","006.png","007.png","008.png","009.png","010.png","011.png",
"012.png","013.png","014.png","015.png","016.png","017.png","018.png","019.png","020.png","021.png",
"022.png","023.png","024.png","025.png","026.png","027.png","028.png","029.png","030.png","031.png",
"032.png","033.png","034.png","035.png","036.png","037.png","038.png","039.png","040.png","041.png",
"042.png","043.png","044.png","045.png","046.png","047.png","048.png","049.png","050.png","051.png",
"052.png","054.png","055.png","056.png","057.png","058.png","059.png","060.png","061.png","097.png",
"098.png","099.png","100.png","101.png","102.png","103.png","104.png","105.png","106.png","107.png",
"108.png","109.png","110.png","111.png","112.png","113.png","114.png","135.png","136.png","137.png",
"138.png","139.png","140.png","141.png","142.png","143.png","144.png","145.png","146.png","147.png",
"148.png","149.png","150.png","151.png","152.png","153.png","154.png","162.png","166.png","169.png",
"170.png","171.png","172.png","173.png","174.png","175.png","176.png","177.png","178.png","179.png",
"180.png","181.png","182.png","183.png","184.png","185.png","186.png","187.png","188.png","189.png",
"190.png","191.png","192.png","193.png","194.png","196.png","197.png","198.png","199.png","200.png",
"201.png","202.png","203.png","204.png","205.png","206.png","207.png","208.png","209.png","210.png",
"211.png","212.png","213.png","214.png","215.png","216.png","219.png","220.png","221.png","223.png",
"224.png","225.png","226.png","227.png","228.png","229.png","230.png","231.png","232.png","233.png",
"234.png","235.png","236.png","237.png","238.png","239.png","240.png","241.png","242.png","243.png",
"244.png","245.png","259.png","260.png","261.png","262.png","263.png","264.png","265.png","266.png",
"267.png","276.png","277.png","278.png","279.png","280.png","281.png","282.png","283.png","284.png",
"285.png","286.png","287.png","288.png","289.png","290.png","291.png","292.png","293.png","294.png",
"295.png","296.png","297.png","298.png","299.png","300.png","301.png","302.png","303.png","304.png",
"305.png","306.png","307.png","308.png","309.png","310.png","311.png","312.png","313.png","314.png",
"315.png","316.png","317.png","318.png","319.png","320.png","321.png","322.png","323.png","324.png",
"328.png","329.png","337.png","338.png","339.png","340.png","341.png","342.png","343.png","344.png",
"345.png","346.png","348.png","349.png","350.png","351.png","352.png","353.png","354.png","355.png",
"356.png","357.png","358.png","359.png","360.png","361.png","362.png","363.png","364.png","365.png",
"366.png","367.png","368.png","369.png","370.png","371.png","373.png","374.png","375.png","376.png",
"377.png","378.png","379.png","381.png","382.png","383.png","384.png","385.png","386.png","387.png",
"388.png","389.png","390.png","391.png","392.png","393.png","394.png","395.png","396.png","397.png",
"398.png","399.png","400.png","401.png","402.png","403.png","404.png","405.png","406.png","407.png",
"408.png","409.png","410.png","411.png","412.png","413.png","414.png","415.png","416.png","417.png",
"418.png","419.png","420.png","421.png","422.png","423.png","424.png","425.png","426.png","427.png",
"428.png","429.png","430.png","431.png","432.png","433.png","435.png","436.png","437.png","438.png",
"439.png","440.png","441.png","442.png","443.png","444.png","445.png","446.png","447.png","448.png",
"449.png","450.png","451.png","452.png","453.png","454.png","455.png","456.png","457.png","458.png",
"459.png","460.png","461.png","462.png","463.png","464.png","465.png","466.png","467.png","468.png",
"469.png","470.png","471.png","472.png","474.png","475.png","476.png","477.png","478.png","479.png",
"480.png","481.png","482.png","483.png","484.png","485.png","486.png","487.png","489.png","490.png",
"491.png","492.png","493.png","494.png","495.png","496.png","497.png","498.png","499.png","500.png",
"501.png","502.png","503.png","504.png","505.png","506.png","507.png","508.png","509.png","510.png",
"511.png","512.png","514.png","515.png","516.png","517.png","518.png","519.png","521.png","522.png",
"523.png","524.png","525.png","526.png","527.png","528.png","529.png","530.png","531.png","532.png",
"533.png","534.png","535.png","536.png","537.png","538.png","539.png","540.png","541.png","542.png",
"543.png","544.png","546.png","547.png","548.png","549.png","550.png","551.png","552.png","553.png",
"554.png","555.png","556.png","557.png","558.png","559.png","560.png","561.png","562.png","563.png",
"564.png","565.png","566.png","567.png","568.png","570.png","571.png","573.png","574.png","575.png",
"576.png","577.png","579.png","580.png","581.png","582.png","583.png","584.png","585.png","586.png",
"587.png","588.png","589.png","590.png","591.png","592.png","593.png","594.png","595.png","596.png",
"597.png","598.png","599.png","600.png","601.png","602.png","603.png","604.png","605.png","606.png",
"607.png","608.png","609.png","610.png","611.png","614.png","615.png"].each do |ai|
  a = Avatar.new
  puts ("Fetching http://lemirror1.com/Development/images/avatars/#{ai}")
  avatar_image = open('http://lemirror1.com/Development/images/avatars/' + ai)
  def avatar_image.original_filename; base_uri.path.split('/').last; end
  a.image = avatar_image.read
  a.image_name = avatar_image.original_filename
  a.description = "Avatar"
  a.save
end


Dir.foreach('public/avatars/football/college') do |item|
  next if item.match(/^\./)
  a = Avatar.new
  a.image = Rails.root.join("public/avatars/football/college/#{item}")
  a.description = item.gsub('.jpg', '').gsub('.png', '').gsub('.gif', '').gsub('_', ' ')
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
  # Create the game liability account for LE
  Plutus::Liability.create(name: @credit_manager.game_account_name)

  # Prepare a school
  @school = FactoryGirl.create(:school, :address => FactoryGirl.create(:address, :state_id => State.find_by_abbr('AL').id))

  # Create a school_admin
  @school_admin = FactoryGirl.create(:school_admin,:user => FactoryGirl.create(:spree_user,:username => 'schooladmin'))
  @school_admin.activate
  @school_admin_link = FactoryGirl.create(:person_school_link, school: @school, person: @school_admin)

  # Create a teacher
  @teacher = FactoryGirl.create(:teacher,:user => FactoryGirl.create(:spree_user,:username => 'teacher'))
  @teacher.activate
  @teacher.save
  @teacher_link = FactoryGirl.create(:person_school_link, school: @school, person: @teacher)

  # Create a LE Admin
  @le_admin = FactoryGirl.create(:le_admin, :user => Spree::User.find(1))
  @le_admin.activate
  @le_admin.username = 'leadmin'
  @le_admin.user.password = "spree123"
  @le_admin.save

  # Give the school some students
  @student1 = FactoryGirl.create(:student, :user => FactoryGirl.create(:spree_user,:username => 'student1', :email => 'student1@example.com'))
  @link1 = FactoryGirl.create(:person_school_link, school: @school, person: @student1)
  @student2 = FactoryGirl.create(:student, :user => FactoryGirl.create(:spree_user,:username => 'student2', :email => 'student2@example.com'))
  @link2 = FactoryGirl.create(:person_school_link, school: @school, person: @student2)
  @student1.activate!
  @student2.activate!

  @classroom = Classroom.create(:name => 'Test Classroom', school_id: @school.id)
  @person_school_classroom_link = PersonSchoolClassroomLink.create(:person_school_link_id => @teacher_link.id,
                                                                   :classroom_id => @classroom.id,
                                                                   :owner => true)


  # ======== GIVE OUT SOME CREDITS ======
  # Issue some credits to the school
  @school_credits = 200_000
  @teacher_credits = 50_000
  @credit_manager.issue_credits_to_school(@school, @school_credits)
  @credit_manager.issue_store_credits_to_school(@school, @school_credits * 2)

  # Give the teacher some credits
  @credit_manager.issue_credits_to_teacher(@school, @teacher, @teacher_credits)

  # Give a student some credits
  @student_credits = 10000
  @credit_manager.issue_ecredits_to_student(@school, @teacher, @student1, @student_credits)
  # ======== /GIVE OUT SOME CREDITS ======
  
  # ======== MESSAGING ========
  @message1 = FactoryGirl.create(:message, from: @student1, to: @student2)
  @message2 = FactoryGirl.create(:message, from: @student2, to: @student1)
  @message3 = FactoryGirl.create(:message, from: @student1, to: @student2)
  @message4 = FactoryGirl.create(:message, from: @student2, to: @student1)
  @message5 = FactoryGirl.create(:message, from: @student1, to: @student2)
  @message6 = FactoryGirl.create(:message, from: @student2, to: @student1)

  # Send some messages from the system to the first student
  @message7 = FactoryGirl.create(:system_message, from: @student2, to: @student1)
  # ======== /MESSAGING ========

  # ======== GAMES ========
  @question1 = FactoryGirl.create(:food_fight_question, body: "Find the least common multiple for each number pair 6 27")
  @answer1 = FactoryGirl.create(:food_fight_answer, body: "54")
  @answer2 = FactoryGirl.create(:food_fight_answer, body: "60")
  @answer3 = FactoryGirl.create(:food_fight_answer, body: "48")
  @answer4 = FactoryGirl.create(:food_fight_answer, body: "27")
  @answer1_link = FactoryGirl.create(:game_question_answer, question: @question1, answer: @answer1, correct: true)
  @answer2_link = FactoryGirl.create(:game_question_answer, question: @question1, answer: @answer2)
  @answer3_link = FactoryGirl.create(:game_question_answer, question: @question1, answer: @answer3)
  @answer4_link = FactoryGirl.create(:game_question_answer, question: @question1, answer: @answer4)
  # ======== /GAMES ========

  # ======== Generate some codes ========
  100.times do
    Code.create
  end
  # ======== /Generate some codes ========


  # ======== STORE SETUP ========
  # create the default store - le wholesale store
  if Rails.env.development?
    port = ':3000'
    host = '.lvh.me'
  else
    port = ''
    host = '.mayhemstaging.lemirror.com'
  end

  @store = Spree::Store.create(code: "le", name: "Learning Earnings Wholesale", default: true, email: "theteam@learningearnings.com", domains: "le#{host}#{port}")

  Rake::Task['db:load_dir'].reenable
  Rake::Task['db:load_dir'].invoke("samples")
  # ======== /STORE SETUP ========

  # ======= Make the teacher have a pending reward delivery =======
  #@reward = Spree::Product.first
  #@reward_delivery  = FactoryGirl.create(:pending_reward_delivery, from: @teacher, to: @student1, reward: @reward)
  # ======= /Make the teacher have a pending reward delivery =======

  # ======== LOCKERS ========
  # Generate some stickers
  sticker_dir = "public/avatars/football/college"
  Dir.foreach(sticker_dir) do |item|
    next if item.match(/^\./)
    s = Sticker.new
    s.image = Rails.root.join("#{sticker_dir}/#{item}")
    s.save
    m = MessageImage.new
    m.image = Rails.root.join("#{sticker_dir}/#{item}")
    m.save
  end
  # ======== /LOCKERS ========


  # ======== Foods ===========
  [
   ["Baked Potato","baked_potato.png"],
   ["Broccoli and Cheese","broccoli_cheese.png"],
   ["Cheese Burger ","cheeseburger.png"],
   ["Cheese","cheese.png"],
   ["Cherry Pie","cherry_pie.png"],
   ["Chocolate Milk","chocolate_milk.png"],
   ["Donut","doughnut.png"],
   ["Eggs","eggs.png"],
   ["Fries","fries.png"],
   ["Hot Dog","hot_dog.png"],
   ["Ice Cream","ice_cream.png"],
   ["Pizza","pizza.png"],
   ["Spagetti","spagetti.png"],
   ["Toast","toast.png"],
   ["Tuna","tuna.png"]
  ].each do |f|
    food = Food.create(name: f[0])
    food.image = open("http://www.lemirror1.com/Development/images/games/foodfight/" + f[1]).read
    #food.image = open(Rails.root.join('app', 'assets', 'images', 'common', 'le_logo.png')).read
    food.save
  end
  # ======== Foods ===========

  # ======== Auctions =========
  auction = FactoryGirl.create(:auction)
  # ======== /Auctions =========
end
