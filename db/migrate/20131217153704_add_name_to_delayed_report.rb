class AddNameToDelayedReport < ActiveRecord::Migration
  def change
    add_column :delayed_reports, :name, :string
  end
end
