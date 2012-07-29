class Teacher < Person
#  has_many :person_school_classroom_links,:class_name => 'PersonSchoolClassroomLink', :source => :person_school_links
#  has_many :classrooms, :through => :person_school_classroom_links, :source => :classroom

end
