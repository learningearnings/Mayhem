module Powerschool
  class Staff < PowerschoolObject
    attr_accessor(:id, :local_id, :admin_username, :teacher_username, :first_name, :middle_name, :last_name, :emails)

    def initialize(options)

      if options.fetch(:values).fetch("name")
        options.fetch(:values).fetch("name").each {|key,value| options.fetch(:values)[key] = value}
        options.fetch(:values).delete("name")
      end

      super
    end

    def user_id
      get_user_id
    end

    private

    def get_user_id
      r = @client.get_table('schoolstaff', self.id, 'users_dcid')
      r.is_a?(Hash) ? r["tables"]["schoolstaff"]["users_dcid"] : nil
    end

  end
end