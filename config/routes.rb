require 'sidekiq/web'
Leror::Application.routes.draw do
  get '/sti/give_credits' => "sti#give_credits"
  post '/sti/link' => "sti#link"
  get '/sti/sync' => "sti#sync"
  post "/sti/create_ebucks_for_students" => 'sti#create_ebucks_for_students'
  match '/404' => 'errors#not_found'
  match '/422' => 'errors#server_error'
  match '/500', :to => 'errors#server_error'
  devise_scope :user do
    match "/logout" => "devise/sessions#destroy", :as => :destroy_user_session
  end
  resources :polls
  match "/vote" => 'polls#vote', :as => 'votes'
  match "/poll_form/:id" => 'polls#poll_form', :as => 'poll_form'

  get "settings/show"

  get "settings/edit"
  match '/uploaded_users/check_valid' => "uploaded_users#check_valid"
  match '/uploaded_users/bulk_upload' => "uploaded_users#bulk_upload"
  resources :uploaded_users do
  end

  # Root route
  root to: 'homes#show'
  match "/filter_widget" => "pages#show", :id => "filter_widget"

  resource :home
  resources :delayed_reports

  resources :people do
    collection do
      match "/get_avatar_results" => 'people#get_avatar_results'
    end
  end

  resource :games, controller: "games/base", only: [:show]

  resources :news_posts, controller: "news", only: [:index, :show]
  match '/pages/parents/news' => 'news#index', visitor_type: 'parent'
  match '/pages/teachers/news' => 'news#index', visitor_type: 'teacher'

  namespace :schools do
    resource :settings, controller: "settings", only: [:show]
    resources :reward_exclusions
    #post "toggle_distributor/:teacher_id(.:format)" => 'settings#toggle_distributor', :as => 'toggle_distributor'
    post "toggle_distributor" => 'settings#toggle_distributor', :as => 'toggle_distributor'
  end

  match '/admin' => redirect('/admin/le_admin_dashboard')

  match "/cancel_auction/:id" => 'auctions#cancel_auction', :as => 'cancel_auction'
  match "/cancel_school_auction/:id" => 'auctions#cancel_school_auction', :as => 'cancel_school_auction'
  # Administrative routes
  ActiveAdmin.routes(self)
  namespace :admin do
    get :delete_student_school_link, :controller => :students, :action => :delete_school_link
    get :delete_teacher_school_link, :controller => :teachers, :action => :delete_school_link
    get :delete_school_admin_school_link, :controller => :school_admins, :action => :delete_school_link
    post 'import_students' => 'imports#import_students', as: :import_students
    post 'import_teachers' => 'imports#import_teachers', as: :import_teachers
    get 'handle_interest' => 'imports#handle_interest', as: :handle_interest
    match "fulfill_auctions/:auction_id" => "auctions#fulfill_auction", as: :fulfill_auction
    match "checking_history/get_history/:person_id" => 'checking_history#get_history', :as => :checking_history
    match "checking_history/get_history" => 'checking_history#get_history', :as => :checking_history
    match "savings_history/get_history/:person_id" => 'savings_history#get_history', :as => :savings_history
    match "savings_history/get_history" => 'savings_history#get_history', :as => :savings_history
  end

  get "/homeroom_check" => "classrooms#homeroom_check", :as => "homeroom_check"
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
  post "/banks/code_lookup" => 'banks#code_lookup'

  # Game routes
  namespace :games do
    resource :food_fight do
      member do
        get  'challenge_opponent'
        post 'play'
        get  'round_end'
        get  'choose_food'
      end
    end
    resource :number_muncher do
    end
  end

  match 'choose_food/:match_id' => 'games/food_fights#choose_food', :as => :choose_food
  match 'throw_food' => 'games/food_fights#throw_food', :as => :throw_food
  match 'food_hit/:match_id' => 'games/food_fights#food_hit', :as => :food_hit
  match 'continue_match/:match_id' => 'games/food_fights#continue_match', :as => :continue_match_games_food_fight
  match 'rematch/:person_id' => 'games/food_fights#rematch', :as => :rematch_games_food_fight
  match "/restock" => 'restock#index', :as => :restock
  match "/restock/empty" => 'restock#empty', :as => :restock_empty_cart


  resources :auctions

  post "/filters/filter_schools_by_state" => "filters#filter_schools_by_state"
  post "/filters/filter_classrooms_by_school" => "filters#filter_classrooms_by_school"
  post "/filters/filter_grades_by_classroom" => "filters#filter_grades_by_classroom"
  post "/filters" => "filters#create"

  match '/reports/refund' => 'reports/purchases#refund_purchase', as: 'refund_purchase'
  match '/reports/student_roster' => 'reports/student_roster#show', as: 'student_roster_report'
  match '/reports/activity' => 'reports/activity#show', as: 'activity_report'

  match '/reports/student_credit_history' => 'reports/student_credit_history#new', as: 'student_credit_history_report'
  get '/reports/student_credit_history/:id' => 'reports/student_credit_history#show', as: 'student_credit_history_report_show'

  match '/reports/purchases' => 'reports/purchases#new', as: 'purchases_report'
  get '/reports/purchases/:id' => 'reports/purchases#show', as: 'purchases_report_show'

  # Messaging routes
  match "inbox/friend_messages" => 'messages#friend_messages', :as => 'friend_messages'
  match "inbox/school_messages" => 'messages#school_messages', :as => 'school_messages'
  match "inbox/teacher_messages" => 'messages#teacher_messages', :as => 'teacher_messages'
  match "inbox/games_messages" => 'messages#games_messages', :as => 'games_messages'
  match "inbox/system_messages" => 'messages#system_messages', :as => 'system_messages'
  match "inbox/:message_id/reply" => 'messages#reply', :as => 'reply_message'
  match "inbox/admin_message" => 'messages#admin_message', :as => 'leadmin_message'
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

  match "/charities" => 'charities#index'
  match "/charity/print/:id" => 'charities#print', :as => :charity_print

  match "/create_classroom_student" => 'classrooms#create_student', :as => 'create_classroom_student'
  namespace :teachers do
    resource :bulk_students
    resources :reports
    resource  :bank
    resource  :dashboard
    resource  :lounge
    resources :rewards
    match "home" => "home#show", as: 'home'
    match "/refund_teacher_reward/:id" => 'rewards#refund_teacher_reward', as: 'refund_teacher_reward'
    match "/print_batch/:id" => 'banks#print_batch', as: 'print_batch', defaults: { :format => 'html' }
    match "/create_print_bucks" => 'banks#create_print_bucks'
    match "/create_ebucks" => 'banks#create_ebucks'
    match "/create_ebucks_for_classroom" => 'banks#create_ebucks_for_classroom'
    match "/transfer_bucks" => 'banks#transfer_bucks'
    match "/new_student" => 'dashboards#new_student'
    match "/create_student" => 'dashboards#create_student'
    match "/edit_student/:id" => 'dashboards#edit_student'
    match "/update_student" => 'dashboards#update_student', :as => 'update_student'
    match "/show_student/:id" => 'dashboards#show', as: "show_student"

    # Messaging routes
    match "inbox/peer_messages" => 'messages#peer_messages', :as => 'peer_messages'
    match "inbox/system_messages" => 'messages#system_messages', :as => 'system_messages'
    match "inbox/admin_message" => 'messages#admin_message', :as => 'leadmin_message'
    match "inbox/classroom_message" => 'messages#classroom_message', :as => 'classroom_message'
    match "inbox/peer_message" => 'messages#peer_message', :as => 'peer_message'
    match "/inbox" => 'messages#index'
    match "inbox/:message_id/reply" => 'messages#reply', :as => 'reply_message'
    resources :messages
  end

  resources :students
  namespace :school_admins do
    resource :bank
    resource :dashboard
    resources :reports
    match "/dashboard" => "dashboard#show", :as => 'dashboard'
    match "/create_print_bucks" => 'banks#create_print_bucks'
    match "/create_ebucks" => 'banks#create_ebucks'
    match "/create_ebucks_for_classroom" => 'banks#create_ebucks_for_classroom'
    match "/transfer_bucks" => 'banks#transfer_bucks'
    match "/new_student" => 'dashboards#new_student'
    match "/create_student" => 'dashboards#create_student'
    match "/new_teacher" => 'dashboards#new_teacher'
    match "/create_teacher" => 'dashboards#create_teacher'
    match "/new_student_import" => "imports#new_student_import", :as => 'new_student_import'
    match "/new_teacher_import" => "imports#new_teacher_import", :as => 'new_teacher_import'
    match "/import_students" => "imports#import_students", :as => 'import_students'
    match "/import_teachers" => "imports#import_teachers", :as => 'import_teachers'
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

  # spree admin manual orders
  match 'create_manual_order'    => 'spree/admin/orders#create_manual_order'
  match 'refresh_school_rewards' => 'spree/admin/orders#refresh_school_rewards'
end

# Any routes we add to Spree go here:
Spree::Core::Engine.routes.prepend do
  resources :auctions
  devise_scope :user do
    post '/reset_password/:resource_name' => 'user_passwords#create', :as => 'reset_password'
    get '/logout' => 'user_sessions#destroy', :as => :get_destroy_user_session
    get '/logout' => 'user_sessions#destroy',:remote => true, :as => :destroy_user_session
  end
  namespace :admin do
    match "le_shipments/ship/:order_number" => "le_shipments#ship", :as => :le_ship_order
    match "le_shipments/print/:order_number" => "le_shipments#print", :as => :le_print_order
    resources :rewards do
      get 'page/:page', :action => :index, :on => :collection
    end
    match 'remove_reward' => 'rewards#destroy'
    match 'undelete_reward/:id' => 'rewards#undelete', :as => :undelete_reward
    resources :le_shipments
  end
end
