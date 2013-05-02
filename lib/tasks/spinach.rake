# Delete the default spinach task and replace with the following...
Rake.application.instance_variable_get('@tasks').delete('spinach')

task :spinach_env do
  ENV['RAILS_ENV'] = 'test'
end

desc 'runs the whole spinach suite'
task :spinach => :spinach_env do
  # Ignore the tests tagged with @wip (work in progress)
  ruby '-S spinach --tags ~@wip ~@bug'
end
