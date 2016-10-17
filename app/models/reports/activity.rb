module Reports
  class Activity < Reports::Base
    include DateFilterable
    include ActionView::Helpers

    attr_accessor :parameters
    attr_reader :school, :data
    def initialize params
      super
      @parameters = Reports::Activity::Params.new(params)
      @school = params[:school]
      @endpoints = date_endpoints(@parameters);
      @classroom = params[:classroom_filter]
      @logged_in_person = params[:logged_in_person]
      @data = []
    end

    def execute!
      #begin
        people.each do |person|
          @data << generate_row(person) 
        end
      #rescue StandardError => e
      #  Rails.logger.fatal("Something went bad wrong")
      #  Rails.logger.fatal(e.to_s + people.to_yaml)
      #rescue NoMethodError => e
      #  Rails.logger.fatal("Something went bad wrong")
      #  Rails.logger.fatal(e.to_s + people.to_yaml)
      #end
    end

    def range
      @endpoints ? "From #{l @endpoints[0]} to #{l @endpoints[1]}" : nil
    end

    def sort_by
      case parameters.sort_by
      when "Default"
        [:scoped]
      when "First, Last"
        [:order, "p.first_name, p.last_name"]
      when "Last, First"
        [:order, "p.last_name, p.first_name"]
      when "Username"
        [:order, "person_username"]
      end
    end
    
    class Params < Reports::ParamsBase
      attr_accessor :date_filter,:sort_by, :classroom_filter
      def initialize options_in = {}
        options_in ||= {}    # def people
        options = options_in[self.class.to_s.gsub("::",'').tableize] || options_in || {}
        [:date_filter, :sort_by, :classroom_filter].each do |iv|
          default_method = (iv.to_s + "_default").to_sym
          default_value = nil
          default_value = send(default_method) if respond_to? default_method
          instance_variable_set(('@' + iv.to_s).to_sym,options[iv] || default_value || "")
        end
      end

      def sort_by_default
        sort_by_options[0]
      end

      def sort_by_options
        ["Default", "First, Last", "Last, First", "Username"]
      end

      def date_filter_options
        [
          ['Last Year', "all"],
          ['Last 90 Days', "last_90_days"],
          ['Last 60 Days', "last_60_days"],
          ['Last Month', "last_month"],
          ['This Month', "this_month"],
          ['This Week', "this_week"],
          ['Last Week', "last_week"],
          ['Last 7 Days', "last_7_days"]
        ]
      end      

      def date_filter_default
        date_filter_options[7][1]
      end

    end
  end
end
