class CreateOtuCodeTypes < ActiveRecord::Migration
  def change
    create_table :otu_code_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
