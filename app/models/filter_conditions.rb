require 'school'
# require 'classroom'
# require 'state'

class FilterConditions
  attr :schools, :classrooms, :states, :person_classes, :minimum_grade, :maximum_grade

  def initialize(d = nil)
    @schools = []
    @classrooms = []
    @person_classes = []
    @states = []
    @minimum_grade = 0
    @maximum_grade = 12
    if d.kind_of? String
      yd = YAML::load(d)
      @schools = yd.schools || []
      @classrooms = yd.classrooms || []
      @person_classes = yd.person_classes || []
      @states = yd.states || []
      @minimum_grade = yd.minimum_grade || 0
      @maximum_grade = yd.maximum_grade || 12
    elsif d.kind_of? FilterConditions
      @schools = d.schools || []
      @classrooms = d.schools || []
      @person_classes = d.person_classes || []
      @states = d.states || []
      @minimum_grade = d.minimum_grade || 0
      @maximum_grade = d.maximum_grade || 12
    elsif d.kind_of? Hash
      @schools = d[:schools] || []
      @classrooms = d[:classrooms] || []
      @person_classes = d[:person_classes] || []
      @states = d[:states] || []
      @minimum_grade = d[:minimum_grade] || 0
      @maximum_grade = d[:maximum_grade] || 12
    end
  end


  def <<(d)
    if d.kind_of? School
      @schools << d.id
    elsif d.kind_of? Classroom
      @classrooms << d.id
    elsif d.kind_of? State
      @states << d.id
    elsif d.kind_of? String
      @person_classes << d
    elsif d.kind_of? Range
      @minimum_grade = d.min
      @maximum_grade = d.max
    elsif d.kind_of? Hash
      @schools = @schools | (d[:schools] | [])
      @classrooms = @classrooms | (d[:classrooms] | [])
      @person_classes = @person_classes |  (d[:person_classes] | [])
      @states = @states | (d[:states] | [])
      @minimum_grade = d[:minimum_grade] || 0
      @maximum_grade = d[:maximum_grade] || 12
    end
  end

  def to_s
    {:minimum_grade => @minimum_grade, :maximum_grade => @maximum_grade,:schools => @schools, :classrooms => @classrooms, :person_classes => @person_classes, :states => @states}.to_yaml.to_s
  end
end
