ActiveAdmin.register Sticker do
  filter :purchasable
  filter :image_uid


  index do
    column :id
    column :school_id
    column :image do |sticker|
      image_tag(sticker.image.thumb('100x75!').url) if sticker.image
    end
    #default_actions
    column :actions do |resource|
      links = link_to I18n.t('active_admin.view'), resource_path(resource)
      links += ' '
      links += link_to I18n.t('active_admin.edit'), edit_resource_path(resource)
      links += ' '
      links += link_to "Delete", resource_path(resource), :confirm => 'Are you sure?', :method => :delete
      links
    end
  end

  form do |f|
    f.inputs "Details" do
      f.input :image, as: :file, label: image_tag(f.object.image.thumb('100x75!').url)
      f.input :min_grade
      f.input :max_grade
      f.input :school, as: :select, collection: School.order(:name)
    end
    f.buttons
  end

end
