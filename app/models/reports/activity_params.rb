module Reports
  class ActivityParams
    include ActiveModel::Validations
    include ActiveModel::Conversion
    extend ActiveModel::Naming

    attr_accessor :date_filter,:sort_by
    def initialize options = {}
      options ||= {}
      self.date_filter = options["date_filter"] || "all"
      self.sort_by = options["sort_by"] || 'Username'
    end

    def persisted?
      false
    end
  end
end
