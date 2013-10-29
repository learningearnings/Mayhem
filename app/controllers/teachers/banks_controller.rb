module Teachers
  class BanksController < Teachers::BaseController
    include Mixins::Banks

    def on_success(obj = nil)
      flash[:notice] = 'Credits sent!'
      if obj.nil? || !obj.is_a?(BuckBatch)
        redirect_to teachers_bank_path
      else
        redirect_to teachers_print_batch_path(obj.id,"pdf")
      end
    end

    def on_failure
      flash[:error] = 'You do not have enough credits.'
      redirect_to :back
    end

    def show
      @buck_batches = current_person.buck_batches(current_school)
    end

    def print_batch
      batch = BuckBatch.find(params[:id])
      respond_to do |format|
        format.pdf {
          html = render_to_string(layout: false , action: "_batch.html.haml", locals: { batch: batch })
          kit = PDFKit.new(html)
          send_data(kit.to_pdf, :filename => "LE_Credits_#{batch.id}.pdf", :type => 'application/pdf') and return
        }
        format.html { render layout: false, action: "_batch.html.haml", locals: { batch: batch } }
      end
    end

    protected
    def person
      current_person
    end
  end
end
