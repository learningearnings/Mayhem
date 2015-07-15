class AddCanDistributeCreditsToPersonSchoolLinks < ActiveRecord::Migration
  def change
    add_column :person_school_links, :can_distribute_credits, :boolean, default: true

    # Update person_school_links#can_distribute_credits to match the current person#can_distribute_credits
    Teacher.find_each do |teacher|
      PersonSchoolLink.where(person_id: teacher.id).update_all(can_distribute_credits: teacher.can_distribute_credits)
    end
  end
end
