class AddInterestPaidAtToSiteSettings < ActiveRecord::Migration
  def change
    add_column :site_settings, :interest_paid_at, :datetime
  end
end
