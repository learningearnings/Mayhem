class CreatePersonAccountLinks < ActiveRecord::Migration
  def change
    create_table :person_account_links do |t|
      t.integer :person_school_link_id
      t.integer :plutus_account_id
      t.boolean :is_main_account

      t.timestamps
    end
    add_index(:person_account_links,[:person_school_link_id,:plutus_account_id],:name => 'index_pal_psl_account')
  end
end
