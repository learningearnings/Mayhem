class CreateCodeEntryAttempts < ActiveRecord::Migration
  def change
    create_table :code_entry_failures do |t|
      t.integer :person_id

      t.timestamps
    end
  end
end
