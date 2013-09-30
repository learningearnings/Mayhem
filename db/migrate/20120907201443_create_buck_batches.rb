class CreateBuckBatches < ActiveRecord::Migration
  def change
    create_table :buck_batches do |t|
      t.string   :name

      t.timestamps
    end
  end
end
