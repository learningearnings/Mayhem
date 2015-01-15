ActiveAdmin.register TourEvent do
  filter :tour_name  
  filter :event_name
  filter :created_at
  filter :elapsed_milliseconds

  menu :parent => "le_admins", :label => "Tour Tracking Data"

  index do
    column :id
    column :person do |tour_event|
      tour_event.person
    end
    column :event_name
    column :tour_name
    column :tour_step
    column :created_at
  end

end
