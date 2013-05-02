class AddImportIndexes < ActiveRecord::Migration
  def up
    add_index(:person_school_classroom_links,[:status,:person_school_link_id,:classroom_id],:name => 'index_pscl_status_psl_classroomid')
    add_index(:person_school_links,[:status,:person_id,:school_id],:name => 'psl_status_person_school')
  end

  def down
  end
end
