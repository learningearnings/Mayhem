class CreateSiteSettings < ActiveRecord::Migration
  def up
    create_table :site_settings do |t|
      t.decimal :student_interest_rate, :precision => 8, :scale => 2
      
      t.timestamps
    end
  end

  def down
    drop_table :site_settings
  end
end
