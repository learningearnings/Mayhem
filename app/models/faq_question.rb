class FaqQuestion < ActiveRecord::Base
  include PgSearch
  multisearchable :against => [:question, :answer]
  attr_accessible :question, :answer, :person_type, :place

  scope :for_student, lambda{where("faq_questions.person_type = ?", 'student') }
  scope :for_teacher, lambda{where("faq_questions.person_type = ?", 'teacher') }

   pg_search_scope :search_any_word,
                   :against => [:question, :answer],
                   :using => {
                     :tsearch => {:any_word => true}
                   }

end
