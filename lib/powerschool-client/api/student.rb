module Powerschool
  class Student < PowerschoolObject
    attr_accessor(:id, :local_id, :state_province_id, :student_username, :first_name, :middle_name, :last_name )
    # These are just hashes
    attr_accessor(:addresses, :alerts, :contact, :contact_info, :demographics, :ethnicity_race, :fees, :initial_enrollment, :phones, :schedule_setup, :school_enrollment)

    def initialize(options)

      if options.fetch(:values).fetch("name")
        options.fetch(:values).fetch("name").each {|key,value| options.fetch(:values)[key] = value}
        options.fetch(:values).delete("name")
      end

      super
    end

    def guardian_info(force_refresh = false)
      get_guardian_info(force_refresh)
    end

    private
    def get_guardian_info(refresh)
      with_local_cache(:guardian_info, refresh) do
        client.get_guardian_info_for_student(id)
      end
    end
  end
end