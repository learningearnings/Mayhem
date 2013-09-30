# Be sure to restart your server when you modify this file.

# Add new mime types for use in respond_to blocks:
# Mime::Type.register "text/richtext", :rtf
# Mime::Type.register_alias "text/html", :iphone
# Mime::Type.register_alias "application/pdf", :pdf
# Mime::Type.register "image/svg+xml", :svg
Mime::Type.register "text/x-component", :htc
Mime::Type.register "image/svg+xml", :svg
Mime::Type.register "application/x-shockwave-flash", :swf
Rack::Mime::MIME_TYPES.merge!({
                                ".htc"     => "text/x-component",
                                ".svg"     => "image/svg+xml",
                                ".swf"     => "application/x-shockwave-flash"
})
