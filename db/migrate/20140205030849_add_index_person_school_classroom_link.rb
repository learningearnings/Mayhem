class AddIndexPersonSchoolClassroomLink < ActiveRecord::Migration
  def up
    add_index "person_school_classroom_links", ["person_school_link_id", "classroom_id"], :name => :pscl_pscli_ci
  end

  def down
  end
end
