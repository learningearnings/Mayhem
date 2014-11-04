class AddIgnoreFieldToPersonSchoolLinksTable < ActiveRecord::Migration
  def change
    add_column :person_school_links, :ignore, :boolean, default: false
  end
end
