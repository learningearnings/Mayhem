class AddPersonSchoolLinkToBuckBatch < ActiveRecord::Migration
  def change
    remove_column :person_buck_batch_links, :person_id
    add_column :person_buck_batch_links, :person_school_link_id, :integer
  end
  def down
    remove_column :person_buck_batch_links, :person_school_link_id
    add_column :person_buck_batch_links, :person_id, :integer
  end
end
