module Reports
  class PurchasesController < Reports::BaseController
    def show
      report = Reports::Purchases.new
      report.execute!
      render 'show', locals: { report: report }
    end
  end
end
