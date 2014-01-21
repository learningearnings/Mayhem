class CreateDelayedReports < ActiveRecord::Migration
  def change
    create_table :delayed_reports do |t|
      t.integer :person_id
      t.string :state
      t.text :report_data

      t.timestamps
    end
  end
end
