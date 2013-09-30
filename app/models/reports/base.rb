module Reports
  class Base
    def initialize params
      @data = []
    end

    def data_rows &block
      @data.each do |datum|
        block.call(datum)
      end
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
