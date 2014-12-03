class CreateFaqQuestions < ActiveRecord::Migration
  def change
    create_table :faq_questions do |t|
      t.text    :question
      t.text    :answer
      t.string  :person_type
      t.integer :place

      t.timestamps
    end
  end
end
