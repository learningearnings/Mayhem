Leror::Application.routes.draw do

  # This line mounts Spree's routes at the root of your application.
  # This means, any requests to URLs such as /products, will go to Spree::ProductsController.
  # If you would like to change where this engine is mounted, simply change the :at option to something different.
  #
  # We ask that you don't use the :as option here, as Spree relies on it being the default of "spree"
  mount Spree::Core::Engine, :at => '/store'

  # Mount the plutus controllers for viewing accounts for basic reporting
  # FIXME: Lock this down before hitting production
  mount Plutus::Engine => "/plutus", :as => "plutus"

  root to: 'pages#show', :id => 'home'
  match "/pages/*id" => 'pages#show', :as => :page, :format => false
 
  ActiveAdmin.routes(self)

  resources :pdfs
  resources :student_transfer_commands
  resource :bank
end

# Any routes we add to Spree go here:
Spree::Core::Engine.routes.prepend do
  match "/get_avatar_results" => 'users#get_avatar_results'
end
