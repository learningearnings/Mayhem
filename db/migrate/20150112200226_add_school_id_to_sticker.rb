class AddSchoolIdToSticker < ActiveRecord::Migration
  def change
    add_column :stickers, :school_id, :integer    
  end
end
