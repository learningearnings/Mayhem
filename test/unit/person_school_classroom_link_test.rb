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
    it "is valid with classroom_id and person_school_link_id" do
      s = FactoryGirl.create(:school)
      p = Student.new(:first_name => 'Unit', :last_name => 'Test', :grade => 1,:user => FactoryGirl.create(:spree_user))
      s.must_be :valid?
      p.must_be :valid?
      s.save
      p.save
      psl = PersonSchoolLink.new(:person_id => p.id,:school_id => s.id)
      psl.must_be :valid?
      psl.save
      c = Classroom.new(:name => "Classroom - is valid with classroom_id and person_school_link_id")
      c.valid?
      c.save
      pscl = subject.new(:person_school_link_id => psl.id, :classroom_id => c.id)
      pscl.must_be :valid?
    end
  end

  describe "Methods" do
    it "can link people to classrooms" do
      s = FactoryGirl.create(:school)
      p = Student.new(:first_name => 'Unit', :last_name => 'Test', :grade => 1,:user => FactoryGirl.create(:spree_user))
      s.must_be :valid?
      p.must_be :valid?
      s.save
      p.save
      p.activate
      psl = PersonSchoolLink.new(:person_id => p.id,:school_id => s.id)
      psl.must_be :valid?
      psl.save
      psl.activate
      c = Classroom.new(:name => "Classroom - is valid with classroom_id and person_school_link_id")
      c.valid?
      c.activate
      c.save
      pscl = subject.new(:person_school_link_id => psl.id, :classroom_id => c.id)
      pscl.must_be :valid?
      pscl.save
      c1 = Classroom.find(c.id)
      psl1 = PersonSchoolLink.find(psl.id)
      c1.students.must_include(p)
    end
    it "won't create duplicate classroom links" do
      s = FactoryGirl.create(:school)
      p = Student.new(:first_name => 'Unit', :last_name => 'Test', :grade => 1,:user => FactoryGirl.create(:spree_user))
      s.must_be :valid?
      p.must_be :valid?
      s.save
      p.save
      p.activate
      psl = PersonSchoolLink.new(:person_id => p.id,:school_id => s.id)
      psl.must_be :valid?
      psl.save
      psl.activate
      c = Classroom.new(:name => "Classroom - is valid with classroom_id and person_school_link_id")
      c.valid?
      c.activate
      c.save
      pscl = subject.new(:person_school_link_id => psl.id, :classroom_id => c.id)
      pscl.must_be :valid?
      pscl.save
      c1 = Classroom.find(c.id)
      psl1 = PersonSchoolLink.find(psl.id)
      c1.students.must_include(p)
      pscl1 = subject.new(:person_school_link_id => psl.id, :classroom_id => c.id)
      pscl1.wont_be :valid?
    end
  end

end
