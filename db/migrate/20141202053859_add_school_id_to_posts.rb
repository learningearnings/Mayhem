class AddSchoolIdToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :school_id, :integer
  end
end
