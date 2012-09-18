Leror::Application.routes.draw do
  # Root route
  root to: 'pages#show', :id => 'home'
  match "/filter_widget" => "pages#show", :id => "filter_widget"

  resources :people

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

  post "/filters/filter_schools_by_state" => "filters#filter_schools_by_state"
  post "/filters/filter_classrooms_by_school" => "filters#filter_classrooms_by_school"
  post "/filters/filter_grades_by_classroom" => "filters#filter_grades_by_classroom"
  post "/filters" => "filters#create"

  match '/reports/purchases' => 'reports/purchases#show', as: 'purchases_report'

  # Messaging routes
  match "inbox/friend_messages" => 'messages#friend_messages', :as => 'friend_messages'
  match "inbox/school_messages" => 'messages#school_messages', :as => 'school_messages'
  match "inbox/teacher_messages" => 'messages#teacher_messages', :as => 'teacher_messages'
  match "inbox/system_messages" => 'messages#system_messages', :as => 'system_messages'
  match "inbox/:message_id/reply" => 'messages#reply', :as => 'reply_message'
  resources :messages

  match "/inbox" => 'messages#index'

  resources :posts
  resources :pdfs

  resources :classrooms
  match "/add_classroom_student" => 'classrooms#add_student', as: 'new_classroom_student'
  get :remove_classroom_student, :controller => :classrooms, :action => :remove_student
  # Student banking bits
  resource :bank
  match "/redeem_bucks" => 'banks#redeem_bucks'
  match "/redeem_bucks/:student_id/:code" => 'banks#redeem_bucks', as: 'redeem_buck'

  # Lockers
  resource :locker

  resource :teachers
  match "/teachers/approve_teacher/:id" => 'teachers#approve_teacher', as: 'approve_teacher'
  match "/teachers/deny_teacher/:id" => 'teachers#deny_teacher', as: 'deny_teacher'

  namespace :teachers do
    resource :bank
    match "/print_batch/:id" => 'banks#print_batch', :as => 'print_batch'
    match "/create_print_bucks" => 'banks#create_print_bucks'
    match "/create_ebucks" => 'banks#create_ebucks'
    match "/transfer_bucks" => 'banks#transfer_bucks'
  end

  namespace :school_admins do
    resource :bank
    match "/create_print_bucks" => 'banks#create_print_bucks'
    match "/create_ebucks" => 'banks#create_ebucks'
    match "/transfer_bucks" => 'banks#transfer_bucks'
  end

  # Command routes
  resources :student_transfer_commands, only: [:create]
  resources :food_fight_play_commands, only: [:create]
  resources :student_message_student_commands, only: [:create]
  resources :deliver_rewards_commands, only: [:create]
  resources :update_locker_sticker_link_positions_commands, only: [:create]
  resources :add_locker_sticker_to_locker_commands, only: [:create]

  # rewards for teachers
  resources :rewards
  match 'remove_reward' => 'rewards#destroy'

end

# Any routes we add to Spree go here:
Spree::Core::Engine.routes.prepend do
  match "/get_avatar_results" => 'users#get_avatar_results'
  namespace :admin do
    resources :rewards
    match 'remove_reward' => 'rewards#destroy'
  end
end
