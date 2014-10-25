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
    end
  end
end
