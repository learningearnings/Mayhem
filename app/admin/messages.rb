ActiveAdmin.register Message do
  scope :for_admin, :default => true

  index do
    column "ID" do |message|
      link_to(message.id, admin_message_path(message))
    end
    column "From" do |message|
      person = Person.find(message.from_id)
      if person.type == Teacher
        link_to(Person.find(message.from_id).full_name, admin_teacher_path(Person.find(message.from_id)))
      else
        link_to(Person.find(message.from_id).full_name, admin_student_path(Person.find(message.from_id)))
      end
    end
    column :subject
    column :body
  end
 
end
