module Reports
  class ParamsBase
    include ActiveModel::Conversion
    include ReportsHelper
    extend ActiveModel::Naming

    def persisted?
      false
    end
  end
end
