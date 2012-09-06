module Reports
  class Base
    def initialize
      @data = []
    end

    def data_rows
      @data
    end

    def headers
      raise Reports::HeadersNotImplementedError
    end

    def header_strings
      headers.values
    end

    def header_keys
      headers.keys
    end
  end

  class HeadersNotImplementedError < Exception; end
end
