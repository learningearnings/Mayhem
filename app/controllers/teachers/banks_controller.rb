module Teachers
  class BanksController < Teachers::BaseController
    include Mixins::Banks

    def on_success(obj = nil)
      flash[:notice] = 'Credits sent!'
      redirect_to teachers_bank_path
    end

    def on_failure
      flash[:error] = 'You do not have enough credits.'
      redirect_to :back
    end

    def show
      #@buck_batches = current_person.buck_batches(current_school)
    end

    def print_batch
      batch = BuckBatch.find(params[:id])
      respond_to do |format|
        format.pdf {
          html = render_to_string("_batch",:formats => [:html], layout: false , locals: { batch: batch })
          Rails.logger.debug(html.inspect)
          kit = PDFKit.new(html)
          send_data(kit.to_pdf, :filename => "LE_Credits_#{batch.id}.pdf", :type => 'application/pdf') and return
        }
        format.html
        format.json { render json: {id: batch.id, processed: batch.processed?} }
      end
      clear_balance_cache!
      
      #MixPanelTrackerWorker.perform_async(current_user.id, 'Print Credits', mixpanel_options)

    end

    protected
    def person
      current_person
    end
  end
end
