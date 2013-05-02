class CreateUploadedUsers < ActiveRecord::Migration
  def change
    create_table :uploaded_users do |t|
      t.string :batch_name
      t.text :original_data
      t.string :first_name
      t.string :last_name
      t.string :username
      t.string :email
      t.integer :grade
      t.string :password
      t.string :type
      t.text :message
      t.integer :school_id
      t.integer :created_by_id
      t.integer :approved_by_id
      t.integer :person_id
      t.string :state

      t.timestamps
    end
  end
end
