class RenameApprovedByToActionedBy < ActiveRecord::Migration
  def change
    rename_column :display_names, :approved_by_id, :actioned_by_id
  end
end
