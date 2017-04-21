module Powerschool

  class PowerschoolObject

    attr_accessor :client

    def initialize(options)
      @associations_cache = {}

      @client = options.delete(:client)
      begin
        options.fetch(:values).each do |key,value|
          send("#{key}=".intern, value) if respond_to?("#{key}=".intern)
        end
      rescue NoMethodError
        puts "NoMethodError: There is no method for one of the keys in your options: #{options}"
        return nil
      end
    end

    private

    # # pass an arbitrary key and a block, and the results of the block
    # # will be placed into a caching attribute at that key location
    def with_local_cache(key, force_refresh, &block)
      raise ScriptError unless block_given?
      if force_refresh || @associations_cache[key].nil?
        results = yield
        @associations_cache[key] = results
      end
      @associations_cache[key]
    end
  end
end