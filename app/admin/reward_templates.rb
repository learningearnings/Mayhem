ActiveAdmin.register RewardTemplate do
  form do |f|
    f.inputs "Details" do
      f.input :name
      f.input :description
      f.input :min_grade, :as => :select, :collection => School.grades, :wrapper_html => {:class => 'horizontal'}
      f.input :max_grade, :as => :select, :collection => School.grades, :wrapper_html => {:class => 'horizontal'}
      f.input :image, as: :file
    end
    f.buttons
  end


end
