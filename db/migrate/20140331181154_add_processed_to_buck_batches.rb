class AddProcessedToBuckBatches < ActiveRecord::Migration
  def change
    add_column :buck_batches, :processed, :boolean
  end
end
