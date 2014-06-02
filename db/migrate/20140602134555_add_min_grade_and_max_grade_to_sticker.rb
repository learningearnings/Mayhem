class AddMinGradeAndMaxGradeToSticker < ActiveRecord::Migration
  def change
    add_column :stickers, :min_grade, :integer
    add_column :stickers, :max_grade, :integer
  end
end
