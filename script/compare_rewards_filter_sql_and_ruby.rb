# This is to compare the output of the RewardsFilter's SQL method versus its
# Ruby method.
#
# It will take in a scope of Students and compare the results of running each
# method, writing each comparison to a text file.
#
# USAGE:
#
#     require "./script/compare_rewards_filter_sql_and_ruby.rb"
#     comparer = CompareRewardsFilterOutput.new
#     comparer.run(Student.limit(10))
#
# The output will be in ./tmp/compare_rewards_filter_output.txt

class CompareRewardsFilterOutput
  def run(student_scope)
    File.open(Rails.root.join("tmp", "compare_rewards_filter_output.txt"), "w") do |output_file|
      compare(student_scope, [:by_classroom, :ruby_by_classroom], output_file)
    end
  end

  private
  def compare(students, methods, output_file)
    students.each do |student|
      STDOUT.puts "trying #{student}"
      compare_student(student, methods, output_file)
    end
  end

  def compare_student(student, methods, output_file)
    line = "Student ID: #{student.id};"
    nums = []
    methods.each do |method|
      num = RewardsFilter.send(method, student, products(student)).count
      nums << num
      line << " #{method}: #{num};"
    end
    line << " matched: #{nums[0] == nums[1]};"
    output_file.puts line
  end

  def products(person)
    with_filters_params = {}
    with_filters_params[:searcher_current_person] = person
    with_filters_params[:current_school] = person.schools.first
    with_filters_params[:classrooms] = person.classrooms.map(&:id)
    Spree::Search::Filter.new(with_filters_params).retrieve_products
  end
end
