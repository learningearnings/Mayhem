class AddSchoolIdToGamesPersonAnswers < ActiveRecord::Migration
  def change
    add_column :games_person_answers, :school_id, :integer
  end
end
