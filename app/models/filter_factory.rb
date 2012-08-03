class FilterFactory
#  def find_or_create_by_conditions(conditions)
#    @filter = find(conditions) || create_filter(conditions)
#  end

  def find(conditions = nil)
    schools = nil
    classrooms = nil
    states = nil
    person_classes = nil
    minimum_grade = 0
    maximum_grade = 12

    if conditions && conditions.minimum_grade
      minimum_grade = conditions.minimum_grade
    end
    if conditions && conditions.maximum_grade
      maximum_grade = conditions.maximum_grade
    end

    f = Filter.where(:minimum_grade => minimum_grade..maximum_grade)
    f = f.where(:maximum_grade => minimum_grade..maximum_grade)

    if(conditions && conditions.schools && conditions.schools.count > 0)
      schools = conditions.schools
    end
    if(conditions && conditions.classrooms && conditions.classrooms.count > 0)
      classrooms = conditions.classrooms
    end
    if(conditions && conditions.states && conditions.states.count > 0)
      states = conditions.states
    end
    if(conditions && conditions.person_classes && conditions.person_classes.count > 0)
      person_classes = conditions.person_classes
    end
    sfl = SchoolFilterLink.where(:school_id => schools)
    f = f.joins(:school_filter_links).merge(sfl)
    cfl = ClassroomFilterLink.where(:classroom_id => classrooms)
    f = f.joins(:classroom_filter_links).merge(cfl)
    stfl = StateFilterLink.where(:state_id => states)
    f = f.joins(:state_filter_links).merge(sfl)
    pcfl = PersonClassFilterLink.where(:person_class => person_classes)
    f = f.joins(:person_class_filter_links).merge(pcfl)
    puts f.to_sql
    f.group('filters.id').first
  end


  def find_or_create_filter(conditions = nil)
    @filter = find(conditions) || Filter.new(:minimum_grade => 0, :maximum_grade => 12)
    return @filter if @filter.id
    minimum_grade = 0
    maximum_grade = 12

    if conditions && conditions.minimum_grade
      minimum_grade = conditions.minimum_grade
    end
    if conditions && conditions.maximum_grade
      maximum_grade = conditions.maximum_grade
    end

    @filter.minimum_grade = minimum_grade
    @filter.maximum_grade = maximum_grade

    puts "Creating this filter"
    if conditions && conditions.schools && conditions.schools.count > 0
      conditions.schools.each do |s|
        @filter.school_filter_links << SchoolFilterLink.new(:school_id => s)
      end
    else
      @filter.school_filter_links << SchoolFilterLink.new(:school_id => nil)
    end
    if conditions && conditions.classrooms && conditions.classrooms.count > 0
      conditions.classrooms.each do |c|
        @filter.classrooms << Classroom.find(c)
      end
    else
      @filter.classroom_filter_links << ClassroomFilterLink.new(:classroom_id => nil)
    end
    if conditions && conditions.states && conditions.states.count > 0
      conditions.states.each do |s|
        @filter.states << State.find(s)
      end
    else
      @filter.state_filter_links << StateFilterLink.new(:state_id => nil)
    end
    if conditions && conditions.person_classes && conditions.person_classes.count > 0
      conditions.person_classes.each do |pc|
        @filter.person_class_filter_links << PersonClassFilterLink.new(:person_class => pc)
      end
    else
      @filter.person_class_filter_links << PersonClassFilterLink.new(:person_class => nil)
    end
    puts @filter.to_yaml.to_s
    @filter
   end

  def filter
    @filter
  end

  def find_filter_membership(person)
    # get the user class ????
    # get the classrooms for this user
    f = Filter.where(:minimum_grade => minimum_grade..maximum_grade)
    f = f.where(:maximum_grade => minimum_grade..maximum_grade)

    school_ids = person.schools.collect do |s|
      s.id
    end
    classroom_ids = person.classrooms.collect do |s|
      s.id
    end
    state_ids = person.schools.collect do |s|
      s.state.id
    end

    sfl = SchoolFilterLink.where(:school_id => school_ids).or(:school_id => nil)
    f = f.joins(:school_filter_links).merge(sfl)
    cfl = ClassroomFilterLink.where(:classroom_id => classroom_ids).or(:classroom_id => nil)
    f = f.joins(:classroom_filter_links).merge(cfl)
    stfl = StateFilterLink.where(:state_id => state_ids).or(:state_id => nil)
    f = f.joins(:state_filter_links).merge(sfl)
    pcfl = PersonClassFilterLink.where(:person_class => person.class).or(:person_class => nil)
    f = f.joins(:person_class_filter_links).merge(pcfl)
    puts f.to_sql
    f.group('filters.id')

  end
end
