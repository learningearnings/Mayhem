class AddJobsTable < ActiveRecord::Migration
  def up
    create_table :jobs do |t|
      t.string :type, default: "started"
      t.string :status
      t.text :details
      t.timestamps
    end
  end

  def down
    drop_table :jobs
  end
end
