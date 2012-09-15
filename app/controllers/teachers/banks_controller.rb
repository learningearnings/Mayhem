module Teachers
  class BanksController < Teachers::BaseController
    include Mixins::Banks
    def on_success
      flash[:notice] = 'Bucks created!'
      redirect_to teachers_bank_path
    end

    def on_failure
      flash.now[:error] = 'You do not have enough bucks.'
      render :show
    end

    def show
      @buck_batches = current_person.buck_batches
    end

    def print_batch
      batch = BuckBatch.find(params[:id])
      buck_printer = BuckPrinter.new
      respond_to do |format|
        #format.html
        format.pdf {
          html = render_to_string(:layout => false , :action => "_batch.html.haml")
          kit = PDFKit.new(html)
          #send_data(kit.to_pdf, :filename => "buck_batch#{batch.id}.pdf", :type => 'application/pdf')
          file = kit.to_file("/buck_batch#{batch.id}.pdf")
          #buck_printer.print_bucks(batch, html)
        }
      end

    end

    protected
    def person
      current_person
    end
  end
end
