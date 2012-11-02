ActiveAdmin.register Post do
  config.filters = false

  form do |f|
    f.inputs do
      f.input :title,:required => true, :label => "Post Title"
      f.input :type,:required => true, :label => "Kind of Post", :as => :select, :collection => [["Tip", "TipPost"], ["Testimonial", "TestimonialPost"], ["News", "NewsPost"], ["Press Release", "PressRelease"]]
      f.input :status,:required => true,:label => "Initial Status", :as => :select, :collection => ['submitted','published','archived','flagged']
    end
    f.inputs "Post Body" do
      f.input :body,:required => true,:label => false, :as => :ckeditor
    end
    f.buttons
  end

  show do
    div(:style => "border: 5px solid black; padding: 10px;") do
      h3 post.title
      div do
        simple_format post.body.html_safe
      end
    end
  end
  controller do
    skip_before_filter :add_current_store_id_to_params
    before_filter :load_post_types, only: [:new, :create, :edit, :update]
    protected
    def load_post_types
      @post_types = [["Tip", "TipPost"], ["Testimonial", "TestimonialPost"], ["News", "NewsPost"], ["Press Release", "PressRelease"]]
    end
  end

  member_action :change_status, :method => :put do
    post = Post.find(params[:id])
    action = params[:new_status]
    post.send(action)
    redirect_to( {:action => :index}, :notice => "Post is now #{post.status}")
  end


  index do
    column :id
    column :title
    column :body
    column :status
    column :published_by
    column "Action" do |p|
      actions = p.status_paths(:from => p.status).flatten.uniq.collect do |t| t.from == p.status ? t : nil end.compact.collect do |transition|
        link_to transition.event.to_s,change_status_admin_post_path(p,:new_status => transition.event)
      end.join('&nbsp;&nbsp;|&nbsp;&nbsp;')
      if actions.blank?
        "No further actions"
      else
        actions.html_safe
      end
    end
    column "Created", :created_at
    default_actions
  end

end
