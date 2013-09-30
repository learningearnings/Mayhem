class RenameApprovedByToActionedBy < ActiveRecord::Migration
  def change
    rename_column :monikers, :approved_by_id, :actioned_by_id
  end
end
