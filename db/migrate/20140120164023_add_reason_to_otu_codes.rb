class AddReasonToOtuCodes < ActiveRecord::Migration
  def change
    add_column :otu_codes, :reason, :string
  end
end
