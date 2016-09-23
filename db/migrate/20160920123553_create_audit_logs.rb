class CreateAuditLogs < ActiveRecord::Migration
  def change
    create_table :audit_logs do |t|
      t.integer :person_id
      t.references :log_event, polymorphic: true, index: true
      t.timestamps
    end
  end
end
