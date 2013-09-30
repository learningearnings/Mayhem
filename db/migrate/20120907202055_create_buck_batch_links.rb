class CreateBuckBatchLinks < ActiveRecord::Migration
  def change
    create_table :buck_batch_links do |t|
      t.integer   :otu_code_id
      t.integer  :buck_batch_id

      t.timestamps
    end
  end
end
