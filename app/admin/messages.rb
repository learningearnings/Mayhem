ActiveAdmin.register Message do
  menu :label => "Inbox"
  scope :for_admin, :default => true

  filter :created_at
  filter :updated_at
  filter :subject
  filter :body
  filter :status
  filter :category

  index do
    column "ID" do |message|
      link_to(message.id, admin_message_path(message))
    end
    column "From" do |message|
      person = Person.find(message.from_id)
      if person.type == "Teacher"
        link_to(Person.find(message.from_id).full_name, admin_teacher_path(Person.find(message.from_id)))
      else
        link_to(Person.find(message.from_id).full_name, admin_student_path(Person.find(message.from_id)))
      end
    end
    column :subject
    column :body
  end

  form :partial => "form"

  controller do
    skip_before_filter :add_current_store_id_to_params
  end

end
