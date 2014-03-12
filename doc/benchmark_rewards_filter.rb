# This is how we benchmarked the speed of the sql for RewardsFilter
# versus Ruby for RewardsFilter
student = Student.last
n = 100

old_logger = ActiveRecord::Base.logger
ActiveRecord::Base.logger = nil

Benchmark.bmbm do |x|
  x.report("sql:") { n.times{ RewardsFilter.by_classroom(student, Spree::Product.scoped) } }
  x.report("ruby:") { n.times{ RewardsFilter.ruby_by_classroom(student, Spree::Product.scoped) } }
end

ActiveRecord::Base.logger = old_logger
