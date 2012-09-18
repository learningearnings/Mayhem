class CreatePersonBuckBatchLinks < ActiveRecord::Migration
  def change
    create_table :person_buck_batch_links do |t|
      t.integer :person_id
      t.integer :buck_batch_id
      t.timestamps
    end
  end
end
