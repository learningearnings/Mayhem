ActiveAdmin.register DisplayName do
  config.filters = false

  scope :approved
  scope :requested, default: true
  scope :rejected

  index do
    column :person_name do |display_name|
      display_name.person.name
    end
    column :most_recent_request? do |display_name|
      display_name.most_recent_request? ? "True" : ""
    end
    column :display_name
    column :state
    column :actioned_by do |display_name|
      display_name.actioned_by.name if display_name.actioned_by
    end
    column "Actions" do |display_name|
      link_html = ""
      link_html += (link_to "Approve", approve_admin_display_name_path(display_name), :method => :put) unless display_name.state == "approved"
      link_html += (link_to "Reject", reject_admin_display_name_path(display_name), :method => :put) unless display_name.state == "rejected"
      link_html.html_safe
    end
  end

  member_action :approve, :method => :put do
    display_name = DisplayName.find(params[:id])
    display_name.approve_with_user(current_user.person)
    redirect_to :action => :index, :notice => "Approved!"
  end

  member_action :reject, :method => :put do
    display_name = DisplayName.find(params[:id])
    display_name.reject_with_user(current_user.person)
    redirect_to :action => :index, :notice => "Rejected!"
  end
end
