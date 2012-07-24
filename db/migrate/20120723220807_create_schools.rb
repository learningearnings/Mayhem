class CreateSchools < ActiveRecord::Migration
  def change
    create_table :schools do |t|
      t.string :name
      t.integer :school_type_id
      t.integer :min_grade
      t.integer :max_grade
      t.string :school_phone
      t.string :school_mail_to
      t.string :logo_uid
      t.string :logo_name
      t.string :mascot_name
      t.boolean :school_demo
      t.string :status
      t.string :timezone
      t.decimal :gmt_offset
      t.string :distribution_model
      t.integer :ad_profile
      t.integer :school_address_id

      t.timestamps
    end
  end
end
