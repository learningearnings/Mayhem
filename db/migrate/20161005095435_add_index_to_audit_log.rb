class AddIndexToAuditLog < ActiveRecord::Migration
  def change
    add_index :audit_logs, :district_guid, allow_nil: true
    add_index :audit_logs, :school_id, allow_nil: true
    add_index :audit_logs, :person_id, allow_nil: true
    add_index :audit_logs, :log_event_type, allow_nil: true
    add_index :audit_logs, :log_event_name, allow_nil: true
  end
end
