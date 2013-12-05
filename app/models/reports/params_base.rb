module Reports
  class ParamsBase
    include ActiveModel::Conversion
    include ReportsHelper
    extend ActiveModel::Naming

    attr_accessor :per_page, :page, :paginate

    def initialize options_in = {}
      if options_in["reports_purchases_params"].present?
        @paginate = options_in["reports_purchases_params"].fetch(:paginate, false)
        @per_page = options_in.fetch(:per_page, 5).to_i
        @page     = options_in.fetch(:page, 1).to_i
      end
    end

    def persisted?
      false
    end
  end
end
