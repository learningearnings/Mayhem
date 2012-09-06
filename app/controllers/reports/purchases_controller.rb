module Reports
  class PurchasesController < Reports::BaseController
    def show
      report = Reports::Purchases.new params.merge(school: current_school)
      report.execute!
      render 'show', locals: { report: report }
    end
  end
end
