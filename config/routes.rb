Leror::Application.routes.draw do
  # Root route
  root to: 'homes#show'
  match "/filter_widget" => "pages#show", :id => "filter_widget"

  resource :home

  resources :people do
    collection do
      match "/get_avatar_results" => 'people#get_avatar_results'
    end
  end

  resource :games, controller: "games/base", only: [:show]

  resources :news_posts, controller: "news", only: [:index, :show]

  match '/admin' => redirect('/admin/le_admin_dashboard')

  # Administrative routes
  ActiveAdmin.routes(self)
  namespace :admin do
    get :delete_student_school_link, :controller => :students, :action => :delete_school_link
    get :delete_teacher_school_link, :controller => :teachers, :action => :delete_school_link
    get :delete_school_admin_school_link, :controller => :school_admins, :action => :delete_school_link
  end

  mount Ckeditor::Engine => '/ckeditor'

  # This line mounts Spree's routes at the root of your application.
  # This means, any requests to URLs such as /products, will go to Spree::ProductsController.
  # If you would like to change where this engine is mounted, simply change the :at option to something different.
  #
  # We ask that you don't use the :as option here, as Spree relies on it being the default of "spree"
  mount Spree::Core::Engine, :at => '/store'

  # Mount the plutus controllers for viewing accounts for basic reporting
  # FIXME: Lock this down before hitting production
  mount Plutus::Engine => "/plutus", :as => "plutus"


  # Handle static pages
  match "/pages/teachers/*id" => 'pages#show', :as => :teacher_page, :format => false, visitor_type: 'teacher'
  match "/pages/parents/*id" => 'pages#show', :as => :parent_page, :format => false, visitor_type: 'parent'
  match "/pages/*id" => 'pages#show', :as => :page, :format => false

  # Buck routes
  match "/create_print_bucks" => 'banks#create_print_bucks'
  match "/create_ebucks" => 'banks#create_ebucks'
  match "/redeem_bucks" => 'banks#redeem_bucks'

  # Game routes
  namespace :games do
    resource :food_fight do
      member do
        get 'play'
        get 'choose_food'
        post 'choose_school'
        post 'throw_food'
      end
    end
  end

  match "/restock" => 'restock#index'


  resources :auctions

  post "/filters/filter_schools_by_state" => "filters#filter_schools_by_state"
  post "/filters/filter_classrooms_by_school" => "filters#filter_classrooms_by_school"
  post "/filters/filter_grades_by_classroom" => "filters#filter_grades_by_classroom"
  post "/filters" => "filters#create"

  match '/reports/purchases' => 'reports/purchases#show', as: 'purchases_report'
  match '/reports/student_roster' => 'reports/student_roster#show', as: 'student_roster_report'
  match '/reports/activity' => 'reports/activity#show', as: 'activity_report'
  match '/reports/student_credit_history' => 'reports/student_credit_history#show', as: 'student_credit_history_report'

  # Messaging routes
  match "inbox/friend_messages" => 'messages#friend_messages', :as => 'friend_messages'
  match "inbox/school_messages" => 'messages#school_messages', :as => 'school_messages'
  match "inbox/teacher_messages" => 'messages#teacher_messages', :as => 'teacher_messages'
  match "inbox/system_messages" => 'messages#system_messages', :as => 'system_messages'
  match "inbox/:message_id/reply" => 'messages#reply', :as => 'reply_message'
  match "inbox/admin_message" => 'messages#admin_message', :as => 'admin_message'
  resources :messages

  match "/inbox" => 'messages#index'

  resources :posts
  resources :pdfs

  resources :classrooms
  match "/add_classroom_student" => 'classrooms#add_student', as: 'new_classroom_student'
  get :remove_classroom_student, :controller => :classrooms, :action => :remove_student
  # Student banking bits
  resource :bank do
    member do
      match 'checking_transactions'
      match 'savings_transactions'
    end
  end
  match "/redeem_bucks" => 'banks#redeem_bucks'
  match "/redeem_bucks/:student_id/:code" => 'banks#redeem_bucks', as: 'redeem_buck'

  # Lockers
  resource :locker do
    member do
      match 'share' => 'lockers#share', as: 'share'
      match 'friends' => 'lockers#friends', as: 'friends'
    end
  end
  match "/lockers/:id" => 'lockers#shared', as: 'shared_locker'

  resource :teachers
  match "/teachers/approve_teacher/:id" => 'teachers#approve_teacher', as: 'approve_teacher'
  match "/teachers/deny_teacher/:id" => 'teachers#deny_teacher', as: 'deny_teacher'
  match "/teachers/silent_deny_teacher/:id" => 'teachers#silent_deny_teacher', as: 'silent_deny_teacher'

  namespace :students do
    match "home" => "home#show", as: 'home'
  end

  namespace :teachers do
    resources :reports
    resource  :bank
    resource  :dashboard
    resource  :lounge
    match "home" => "home#show", as: 'home'
    match "/print_batch/:id" => 'banks#print_batch', as: 'print_batch'
    match "/create_print_bucks" => 'banks#create_print_bucks'
    match "/create_ebucks" => 'banks#create_ebucks'
    match "/transfer_bucks" => 'banks#transfer_bucks'
    match "/new_student" => 'dashboards#new_student'
    match "/create_student" => 'dashboards#create_student'

    # Messaging routes
    match "inbox/peer_messages" => 'messages#peer_messages', :as => 'peer_messages'
    match "inbox/system_messages" => 'messages#system_messages', :as => 'system_messages'
    match "inbox/admin_message" => 'messages#admin_message', :as => 'admin_message'
    match "inbox/classroom_message" => 'messages#classroom_message', :as => 'classroom_message'
    match "inbox/peer_message" => 'messages#peer_message', :as => 'peer_message'
    match "/inbox" => 'messages#index'
    match "inbox/:message_id/reply" => 'messages#reply', :as => 'reply_message'
    resources :messages
  end

  namespace :school_admins do
    resource :bank
    resource :dashboard
    match "/create_print_bucks" => 'banks#create_print_bucks'
    match "/create_ebucks" => 'banks#create_ebucks'
    match "/transfer_bucks" => 'banks#transfer_bucks'
    match "/new_student" => 'dashboards#new_student'
    match "/create_student" => 'dashboards#create_student'
    match "/new_teacher" => 'dashboards#new_teacher'
    match "/create_teacher" => 'dashboards#create_teacher'
  end

  # Command routes
  resources :student_transfer_commands, only: [:create]
  resources :food_fight_play_commands, only: [:create]
  resources :student_message_student_commands, only: [:create]
  resources :student_message_admin_commands, only: [:create]
  resources :teacher_message_peer_commands, only: [:create]
  resources :teacher_message_admin_commands, only: [:create]
  resources :teacher_message_classroom_commands, only: [:create]
  resources :student_share_locker_message_commands, only: [:create]
  resources :deliver_rewards_commands, only: [:create]
  resources :update_locker_sticker_link_positions_commands, only: [:create]
  resources :add_locker_sticker_to_locker_commands, only: [:create]
  resources :remove_locker_sticker_from_locker_commands, only: [:create]
  resources :bid_on_auction_commands, only: [:create]

  # rewards for teachers
  resources :rewards
  match 'remove_reward' => 'rewards#destroy'
  match "/get_image_results" => 'messages#get_image_results'
end

# Any routes we add to Spree go here:
Spree::Core::Engine.routes.prepend do

  devise_scope :user do
    get '/logout' => 'user_sessions#destroy', :as => :get_destroy_user_session
  end
#  match "/user/logout(.:format)" => "user_sessions#destroy", :via => :get, :as => :get_destroy_user_session
  namespace :admin do
    match "le_shipments/ship/:order_number" => "le_shipments#ship", :as => :le_ship_order
    match "le_shimpents/print/:order_number" => "le_shipments#print", :as => :le_print_order
    resources :rewards
    match 'remove_reward' => 'rewards#destroy'
    resources :le_shipments
  end
end
