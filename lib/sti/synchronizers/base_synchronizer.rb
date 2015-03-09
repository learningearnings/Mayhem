module STI
  module Synchronizers
    class BaseSynchronizer
      def initialize(data, district_guid)
        @data = data
        @district_guid = district_guid
      end

      private

      def inserted
        @data["Inserted"]
      end

      def deleted
        @data["Deleted"]
      end

      def updated
        @data["Updated"]
      end

      def current_version
        @data["CurrentVersion"]
      end

      def update_current_version(field)
        district = District.where(guid: @district_guid)
        district.update_attribute(field, current_version)
      end
    end
  end
end
