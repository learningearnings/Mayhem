require 'dragonfly/rails/images'
app = Dragonfly[:images]
app.configure do |c|
  c.allow_fetch_file = true
end
