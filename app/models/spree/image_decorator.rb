Spree::Image.class_eval do
    #validates_attachment_size :attachment, :less_than => 2.megabytes, :message => 'file size maximum 2 mb allowed'
    has_attached_file :attachment,
                      :styles => { :mini => '48x48>', :small => '100x100>', :product => '240x240>', :large => '600x600>' },
                      :default_style => :product,
                      :url => '/spree/products/:id/:style/:basename.:extension',
                      :path => '/public/spree/products/:id/:style/:basename.:extension'

    include Spree::Core::S3Support
    supports_s3 :attachment

    Spree::Image.attachment_definitions[:attachment][:styles] = ActiveSupport::JSON.decode(Spree::Config[:attachment_styles])
    Spree::Image.attachment_definitions[:attachment][:path] = Spree::Config[:attachment_path]
    Spree::Image.attachment_definitions[:attachment][:url] = Spree::Config[:attachment_url]
    Spree::Image.attachment_definitions[:attachment][:default_url] = Spree::Config[:attachment_default_url]
    Spree::Image.attachment_definitions[:attachment][:default_style] = Spree::Config[:attachment_default_style]
end
