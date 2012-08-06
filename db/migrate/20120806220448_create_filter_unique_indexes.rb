class CreateFilterUniqueIndexes < ActiveRecord::Migration
  def up
    add_index :state_filter_links, [:filter_id,:state_id], :unique => true
    add_index :classroom_filter_links, [:filter_id,:classroom_id], :unique => true
    add_index :school_filter_links, [:filter_id,:school_id], :unique => true
    add_index :person_class_filter_links, [:filter_id,:person_class], :unique => true
  end

  def down
    remove_index :state_filter_links, :column => [:filter_id,:state_id], :unique => true
    remove_index :classroom_filter_links, :column =>  [:filter_id,:classroom_id], :unique => true
    remove_index :school_filter_links, :column => [:filter_id,:school_id], :unique => true
    remove_index :person_class_filter_links, :column => [:filter_id,:person_class], :unique => true
  end
end
