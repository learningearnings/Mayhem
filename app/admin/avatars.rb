ActiveAdmin.register Avatar do
  filter :created_at
  filter :image_name
  filter :description
  index do
    column :id do |avatar|
      link_to(avatar.id,admin_avatar_path(avatar))
    end
    column :image do |avatar|
      link_to(image_tag(avatar.image.thumb('50x50#').url),admin_avatar_path(avatar))
    end
    column :image_name
    column :description
    column :teacher_only
    column :created_at do |avatar|
      l(avatar.created_at)
    end
    column :updated_at do |avatar|
      l(avatar.updated_at)
    end
    column :actions do |avatar|
      link_to('Edit', edit_admin_avatar_path(avatar)) +
      "&nbsp;|&nbsp;".html_safe +
      link_to('Delete', edit_admin_avatar_path(avatar))
    end
  end

  form do |f|

    f.inputs "Details" do
      f.input :teacher_only
      f.input :image_uid
      f.input :image_name
      f.input :description
      #f.input :image, as: :dragonfly, input_html: { components: [:preview, :upload, :url, :remove ] }
      f.input :image, as: :file
    end
    f.buttons
  end

end
