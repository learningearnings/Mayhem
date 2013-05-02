class CreateInteractions < ActiveRecord::Migration
  def change
    create_table :interactions do |t|
      t.integer :person_id
      t.string  :page
      t.inet    :ip_address
      t.date    :date
      t.integer :elapsed_milliseconds
      t.integer :memory_usage_kb
      t.timestamps
    end
  end
end
