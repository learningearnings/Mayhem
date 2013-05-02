class AddGameAndFoodFightTables < ActiveRecord::Migration
  def change
    create_table :games_questions do |t|
      t.string :type
      t.integer :category_id
      t.integer :number_of_answers
      t.integer :grade
      t.string :body
      t.integer :approval_count
      t.integer :teacher_id
      t.integer :created_by
      t.integer :updated_by
      t.string :status
      t.string :game_type
    end

    create_table :games_answers do |t|
      t.string :game_type
      t.string :body
    end

    create_table :games_question_answers do |t|
      t.integer :question_id
      t.integer :answer_id
      t.boolean :correct
      t.string :status
    end

    create_table :games_question_categories do |t|
      t.string :subject
      t.string :category
      t.string :status
    end

    create_table :games_question_groupings do |t|
      t.string :abbr
      t.string :description
      t.integer :teacher_id
      t.integer :filter_id
      t.string :status
      t.string :game_type
    end

    create_table :games_food_fight_rounds do |t|
      t.string :abbr
      t.string :description
      t.integer :filter_id
      t.integer :question_group_id
      t.datetime :start_date
      t.datetime :end_date
    end

    create_table :games_food_fight_user_statistics do |t|
      t.integer :user_id
      t.integer :round_id
      t.integer :answered
      t.integer :throws
      t.integer :correct
    end

    create_table :games_food_fight_items do |t|
      t.string :name
      t.string :image_uid
      t.string :image_name
      t.string :splat_uid
      t.string :splat_name
      t.integer :unlock_count
    end

    create_table :games_food_fight_throws do |t|
      t.integer :round_id
      t.integer :user_id
      t.integer :user_answer_id
      t.integer :food_item_id
      t.string :target_type
      t.integer :target_id
    end
  end
end
