class AddStatusToStiLinkToken < ActiveRecord::Migration
  def change
    add_column :sti_link_tokens, :status, :string, default: 'active'
  end
end
