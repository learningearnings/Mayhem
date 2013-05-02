class AddMoreIndexesForImport < ActiveRecord::Migration
  def up
    add_index :person_school_links, [:person_id, :school_id], :unique => true, :name => :idx_psl_person_id_school_id
    add_index :person_account_links, :plutus_account_id, :name => :idx_pal_plutus_account_id
    add_index :spree_users, :username, :name => :su_username
    add_index :spree_users, :person_id, :unique => true, :name => :su_person_id
    add_index :people, :legacy_user_id, :unique => true, :name => :ppl_legacy_user_id
  end

  def down
    remove_index :person_school_links, :name => :idx_psl_person_id_school_id
    remove_index :person_account_links, :name => :idx_pal_plutus_account_id
    remove_index :spree_users, :name => :su_username
    remove_index :spree_users, :name => :su_person_id
    remove_index :people, :name => :ppl_legacy_user_id
  end
end
