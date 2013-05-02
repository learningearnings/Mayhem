require 'common_person_config'
module Admin
  ActiveAdmin.register Teacher do
    include CommonPersonConfig
    menu :parent => "Schools", :priority => 1
  end
end
