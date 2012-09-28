ActiveAdmin.register Moniker do
  config.filters = false

  scope :approved
  scope :requested, default: true
  scope :rejected

  index do
    column :person_name do |moniker|
      moniker.person.name
    end
    column :most_recent_request? do |moniker|
      moniker.most_recent_request? ? "True" : ""
    end
    column :moniker
    column :state
    column :actioned_by do |moniker|
      moniker.actioned_by.name if moniker.actioned_by
    end
    column "Actions" do |moniker|
      link_html = ""
      link_html += (link_to "Approve", approve_admin_moniker_path(moniker), :method => :put) + " " unless moniker.state == "approved"
      link_html += (link_to "Reject", reject_admin_moniker_path(moniker), :method => :put) unless moniker.state == "rejected"
      link_html.html_safe
    end
  end

  member_action :approve, :method => :put do
    moniker = Moniker.find(params[:id])
    moniker.approve_with_user(current_user.person)
    redirect_to :action => :index, :notice => "Approved!"
  end

  member_action :reject, :method => :put do
    moniker = Moniker.find(params[:id])
    moniker.reject_with_user(current_user.person)
    redirect_to :action => :index, :notice => "Rejected!"
  end
end
