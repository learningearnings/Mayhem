class AddGamesPersonAnswers < ActiveRecord::Migration
  def change
    create_table "games_person_answers", :force => true do |t|
      t.integer   "person_id"
      t.integer   "question_id"
      t.integer   "question_answer_id"
      t.integer   "elapsed_time"
      t.timestamps
    end
  end
end
