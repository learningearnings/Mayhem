class CreateOtuCodes < ActiveRecord::Migration
  def change
    create_table :otu_codes do |t|
      t.string   :code
      t.integer  :person_school_link_id
      t.integer  :student_id
      t.decimal  :points, :percision => 8, :scale => 2, :null => false
      t.datetime :expires_at
      t.datetime :redeemed_at
      t.boolean  :ebuck, :default => false
      t.boolean  :active, :default => true
      t.integer  :otu_transaction_link_id

      t.timestamps
    end
  end
end
