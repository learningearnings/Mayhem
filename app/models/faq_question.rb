class FaqQuestion < ActiveRecord::Base
  include PgSearch
  attr_accessible :question, :answer, :person_type, :place
  attr_accessible :question, :answer, :person_type, :place, as: :admin

  scope :for_student, lambda{where("faq_questions.person_type = ?", 'student') }
  scope :for_teacher, lambda{where("faq_questions.person_type = ?", 'teacher') }
  scope :for_school_admin, lambda{where(person_type: ['teacher', 'school_admin']) }

  pg_search_scope :kinda_matching,
                  :against => [:question, :answer],
                  :using => {
                    :tsearch => {:dictionary => "english"}
                  }
end
