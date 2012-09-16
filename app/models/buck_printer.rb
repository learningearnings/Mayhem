class BuckPrinter
  require 'haml'
  require 'tilt'

  def initialize()
  end

  def print_bucks(bucks, html)
    #html = Tilt::HamlTemplate.new('app/views/otu_codes/show.html.haml').render(nil, :bucks => bucks)
    kit = PDFKit.new(html)

    #kit.stylesheets << "#{Rails.root}/app/assets/stylesheets/_layout.css.scss"

    # Get an inline PDF
    pdf = kit.to_pdf
    
    # # Save the PDF to a file
    send_data(kit.to_pdf, :filename => "labels.pdf", :type => 'application/pdf')
    #file = kit.to_file("/pdf_test.pdf")
  end
end
