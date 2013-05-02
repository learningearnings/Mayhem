class CreateCodes < ActiveRecord::Migration
  def change
    create_table :codes do |t|
      t.string  :code
      t.boolean :active, :default => true
      t.datetime :used_date

      t.timestamps
    end
  end
end
