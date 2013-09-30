require 'common_person_config'
ActiveAdmin.register Student do
  include CommonPersonConfig
  menu :parent => "Schools", :priority => 3
end
