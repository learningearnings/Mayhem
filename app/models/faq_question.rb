class FaqQuestion < ActiveRecord::Base
  include PgSearch
  attr_accessible :question, :answer, :person_type, :place
  attr_accessible :question, :answer, :person_type, :place, as: :admin

  def self.for_person_type(person_type)
    # TODO: Find a better way to do this
    person_type = ['SchoolAdmin', 'Teacher'] if person_type == 'SchoolAdmin'
    where(person_type: person_type)
  end

  pg_search_scope :kinda_matching,
                  :against => [:question, :answer],
                  :using => {
                    :tsearch => {:dictionary => "english"}
                  }
end
