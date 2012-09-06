module Reports
  class PurchasesController < Reports::BaseController
    def show
      report = Reports::Purchases.new school: current_school
      report.execute!
      render 'show', locals: { report: report }
    end
  end
end
