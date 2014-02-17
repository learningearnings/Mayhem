ActiveAdmin.register SyncAttempt do
  index do
    column :created_at
    column :district_guid
    column :status
  end
end
