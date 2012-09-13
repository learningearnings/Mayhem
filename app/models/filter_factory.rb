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
    f.group('filters.id,filters.minimum_grade, filters.maximum_grade, filters.nickname').first
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
    @filter
   end

  def filter
    @filter
  end

  def find_filter_membership(person)
    # get the user class ????
    # get the classrooms for this user
    f = Filter.where('minimum_grade <= ?',person.grade)
    f = f.where('maximum_grade >= ?',person.grade )

    school_ids = person.schools.collect do |s|
      s.id
    end
    classroom_ids = []
    classroom_ids = person.classrooms.collect do |s|
      s.id
    end
    state_ids = person.schools.collect do |s|
      if s.addresses && s.addresses.first && s.addresses.first.state
        s.addresses.first.state.id
      else
        nil
      end
    end
    sfl_arel = SchoolFilterLink.arel_table
    sfl = SchoolFilterLink.where(sfl_arel[:school_id].in(school_ids).or(sfl_arel[:school_id].eq(nil)))
    f = f.joins(:school_filter_links).merge(sfl)
    cfl_arel = ClassroomFilterLink.arel_table
    cfl = ClassroomFilterLink.where(cfl_arel[:classroom_id].in(classroom_ids).or(cfl_arel[:classroom_id].eq(nil)))
    f = f.joins(:classroom_filter_links).merge(cfl)
    stfl_arel = StateFilterLink.arel_table
    stfl = StateFilterLink.where(stfl_arel[:state_id].in(state_ids).or(stfl_arel[:state_id].eq(nil)))
    f = f.joins(:state_filter_links).merge(sfl)
    pcfl_arel = PersonClassFilterLink.arel_table
    pcfl = PersonClassFilterLink.where(pcfl_arel[:person_class].in(person.class.to_s).or(pcfl_arel[:person_class].eq(nil)))
    f = f.joins(:person_class_filter_links).merge(pcfl)
    f = f.select('filters.id').group('filters.id, filters.minimum_grade, filters.maximum_grade, filters.nickname')
    f.all
  end
end
