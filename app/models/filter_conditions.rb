require 'school'
# require 'classroom'
# require 'state'


class FilterConditions
  def initialize(d = nil)
    @schools = []
    @classrooms = []
    @person_classes = []
    @states = []
    if d.kind_of? String
      yd = YAML::load(d)
      @schools = yd.schools || []
      @classrooms = yd.classrooms || []
      @person_classes = yd.person_classes || []
      @states = yd.states || []
    elsif d.kind_of? FilterConditions
      @schools = d.schools || []
      @classrooms = d.schools || []
      @person_classes = d.person_classes || []
      @states = d.states || []
    elsif d.kind_of? Hash
      @schools = d[:schools] || []
      @classrooms = d[:classrooms] || []
      @person_classes = d[:person_classes] || []
      @states = d[:states] || []
    end
  end

  def schools
    @schools
  end

  def classrooms
    @classrooms
  end

  def person_classes
    @person_classes
  end

  def states
    @states
  end

  def <<(d)
    if d.kind_of? School
      @schools << d.id
#    elsif d.kind_of? Classroom
#      @classrooms << d.id
#    elsif d.kind_of? State
#      @states << d.id
    elsif d.kind_of? String
      @person_classes << d
    elsif d.kind_of? Hash
        @schools = @schools | (d[:schools] | [])
        @classrooms = @classrooms | (d[:classrooms] | [])
        @person_classes = @person_classes |  (d[:person_classes] | [])
        @states = @states | (d[:states] | [])
    end
  end

  def to_s
    {:schools => @schools, :classrooms => @classrooms, :person_classes => @person_classes, :states => @states}.to_yaml.to_s
  end

end
