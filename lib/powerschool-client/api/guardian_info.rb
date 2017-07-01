module Powerschool
  class Guardian < PowerschoolObject
    attr_accessor(:dcid, :firstname, :lastname, :state_guardiannumber, :guardianemail, :emailaddress,:username)

    def initialize(options)
      if options.fetch(:values)["tables"]
        ["pcas_contact","pcas_account", "pcas_emailcontact", "students", "guardian"].each do |association_name|
          if options.fetch(:values).fetch("tables")[association_name]
            options.fetch(:values).fetch("tables").fetch(association_name).each {|key,value| options.fetch(:values)[key] = value}
            options.fetch(:values).fetch("tables").delete(association_name)
          end
        end

        options.fetch(:values).delete("tables")
      end

      super
    end
  end
end
