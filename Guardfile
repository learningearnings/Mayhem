# A sample Guardfile
# More info at https://github.com/guard/guard#readme

notification :libnotify, :timeout => 5, :transient => true, :append => false, :urgency => :critical

guard 'minitest' do
  # with Minitest::Unit
  watch(%r|^test/(.*)\/?(.*)_test\.rb|)
  watch(%r|^lib/(.*)([^/]+)\.rb|)        { |m| "test/#{m[1]}#{m[2]}_test.rb" }
  watch(%r|^test/test_helper\.rb|)       { "test" }

  # Rails 3.2
  watch(%r|^app/controllers/(.*)\.rb|) { |m| "test/controllers/#{m[1]}_test.rb" }
  watch(%r|^app/helpers/(.*)\.rb|)     { |m| "test/helpers/#{m[1]}_test.rb" }
  watch(%r|^app/models/(.*)\.rb|)      { |m| "test/unit/#{m[1]}_test.rb" }
end

guard 'spinach' do
  watch(%r|^features/(.*)\.feature$|)
  watch(%r|^features/steps/(.*)([^/]+)\.rb$|) do |m|
    "features/#{m[1]}#{m[2]}.feature"
  end
end
