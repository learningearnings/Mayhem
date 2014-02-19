ActiveAdmin.register SyncAttempt do
  index do
    column :created_at
    column :total_time do |object|
      if object.status == "Running" || object.status == "Failed" || object.status == "Success"
        distance_of_time_in_words(object.created_at, object.updated_at)
      else
        "N/A"
      end
    end
    column :district_guid
    column :status
    column :error
  end
end
