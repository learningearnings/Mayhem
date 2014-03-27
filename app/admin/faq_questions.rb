ActiveAdmin.register FaqQuestion do

  form do |f|
    f.inputs "Details" do
      f.input :place, :as => :string
      f.input :person_type, :as => :select, :collection => ['student', 'teacher', 'school_admin']
      f.input :question, :as => :string
      f.input :answer, :as => :string
    end
    f.buttons
  end

end
