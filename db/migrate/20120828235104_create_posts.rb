class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.text :body
      t.string :status
      t.string :type
      t.integer :person_id
      t.integer :filter_id
      t.integer :published_by

      t.timestamps
    end
  end
end
