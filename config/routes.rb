Leror::Application.routes.draw do
  # Root route
  root to: 'pages#show', :id => 'home'

  # Administrative routes
  ActiveAdmin.routes(self)
  namespace :admin do
    get :delete_student_school_link, :controller => :students, :action => :delete_school_link
    get :delete_teacher_school_link, :controller => :teachers, :action => :delete_school_link
    get :delete_school_admin_school_link, :controller => :school_admins, :action => :delete_school_link
  end

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
  
  # Game routes
  namespace :games do
    resource :food_fight do
      member do
        get 'play'
      end
    end
  end

  match '/reports/purchases' => 'reports/purchases#show', as: 'purchases_report'

  # Messaging routes
  resources :messages
  match "/inbox" => 'messages#index'

  resources :pdfs

  # Student banking bits
  resource :bank
  match "/redeem_bucks" => 'banks#redeem_bucks'
  match "/redeem_bucks/:student_id/:code" => 'banks#redeem_bucks', as: 'redeem_buck'

  namespace :teachers do
    resource :bank
    match "/create_print_bucks" => 'banks#create_print_bucks'
    match "/create_ebucks" => 'banks#create_ebucks'
  end

  namespace :school_admins do
    resource :bank
    match "/create_print_bucks" => 'banks#create_print_bucks'
    match "/create_ebucks" => 'banks#create_ebucks'
  end

  # Command routes
  resources :student_transfer_commands, only: [:create]
  resources :food_fight_play_commands, only: [:create]
  resources :student_message_student_commands, only: [:create]
end

# Any routes we add to Spree go here:
Spree::Core::Engine.routes.prepend do
  match "/get_avatar_results" => 'users#get_avatar_results'
end
