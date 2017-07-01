class AddReportFieldsToAuditLog < ActiveRecord::Migration
  def change
  	add_column :audit_logs, :district_guid, :string
  	add_column :audit_logs, :school_id, :integer
  	add_column :audit_logs, :school_sti_id, :integer
  	add_column :audit_logs, :person_sti_id, :integer
  	add_column :audit_logs, :person_name, :string
  	add_column :audit_logs, :person_type, :string
  	add_column :audit_logs, :log_event_name, :string
  end
end
