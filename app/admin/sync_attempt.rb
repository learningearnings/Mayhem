ActiveAdmin.register SyncAttempt do
  index do
    column :created_at
    column :total_time do |object|
      distance_of_time_in_words(object.created_at, object.updated_at)
    end
    column :district_guid
    column :status
    column :error
  end
end
