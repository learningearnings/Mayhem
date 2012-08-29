class CreateOtuTransactionLinks < ActiveRecord::Migration
  def change
    create_table :otu_transaction_links do |t|
      t.integer  :otu_code_id
      t.integer  :transaction_id

      t.timestamps
    end
  end
end
