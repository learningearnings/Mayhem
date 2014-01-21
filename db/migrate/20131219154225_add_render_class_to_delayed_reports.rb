class AddRenderClassToDelayedReports < ActiveRecord::Migration
  def change
    add_column :delayed_reports, :render_class, :string
  end
end
