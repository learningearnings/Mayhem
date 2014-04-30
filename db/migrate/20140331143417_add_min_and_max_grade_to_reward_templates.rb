class AddMinAndMaxGradeToRewardTemplates < ActiveRecord::Migration
  def change
    add_column :reward_templates, :min_grade, :integer
    add_column :reward_templates, :max_grade, :integer
    add_column :reward_templates, :image_uid, :string
  end
end
