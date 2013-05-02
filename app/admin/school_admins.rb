require 'common_person_config'

ActiveAdmin.register SchoolAdmin do
  include CommonPersonConfig
  menu :parent => "Schools", :priority => 2
end
