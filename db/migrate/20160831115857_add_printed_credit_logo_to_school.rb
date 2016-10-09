class AddPrintedCreditLogoToSchool < ActiveRecord::Migration
  def up
    # skip this migration if the attribute already exists because of advanced taxon extension
    add_column :schools, :printed_credit_logo_uid, :string
  end
  def down
    remove_column :schools, :printed_credit_logo_uid
  end
end
