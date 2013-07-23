module SchoolAdmins
  class ReportsController < SchoolAdmins::BaseController
    def index
      render '/teachers/reports/index'
    end
  end
end
