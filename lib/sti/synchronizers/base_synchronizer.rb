module STI
  module Synchronizers
    class BaseSynchronizer
      def initialize(data, district_guid)
        @data = data
        @district_guid = district_guid
      end

      private

      def inserted
        begin
          return @data["Inserted"]
        rescue
          return nil
        end
      end

      def deleted
        begin
          return @data["Deleted"]
        rescue
          return nil
        end  
      end

      def updated
        begin
          return @data["Updated"]
        rescue
          return nil
        end  
      end

      def current_version
        begin
          return @data["CurrentVersion"]
        rescue
          return nil
        end
      end

      def update_current_version(field)
        district = District.where(guid: @district_guid).first
        district.update_attribute(field, current_version)
      end
    end
  end
end
