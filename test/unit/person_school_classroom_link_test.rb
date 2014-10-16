require 'test_helper_with_rails'

describe PersonSchoolClassroomLink do
  subject {PersonSchoolClassroomLink}

  describe "Validations" do
    it "wont be valid without person_school_link_id" do
      pscl = subject.new(:classroom_id => 1)
      pscl.wont_be :valid?
    end
    it "wont be valid without classroom_id" do
      pscl = subject.new(:person_school_link_id => 1)
      pscl.wont_be :valid?
    end
  end
end
