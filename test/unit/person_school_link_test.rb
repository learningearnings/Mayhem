require 'test_helper'

describe PersonSchoolLink do
  subject {PersonSchoolLink}

  it "has the basics down" do
    subject.must_be_kind_of Class
  end


  describe "Validations" do
    it "wont be valid without person_id" do
      psl = subject.new(:school_id => 1)
      psl.wont_be :valid?
    end
    it "wont be valid without school_id" do
      psl = subject.new(:person_id => 1)
      psl.wont_be :valid?
    end
    it "is valid with school_id and person_id" do
      s = School.new(:name => "Unit Test School - is valid with school_id and person_id")
      p = Student.new(:first_name => 'Unit', :last_name => 'Test', :grade => 1)
      s.must_be :valid?
      p.must_be :valid?
      s.save
      p.save
      psl = subject.new(:person_id => p.id,:school_id => s.id)
      psl.must_be :valid?
    end
  end

  describe "Methods" do
    it "can link persons to schools" do
      s = School.new(:name => "Unit Test School - can link persons to schools")
      p = Student.new(:first_name => 'Unit', :last_name => 'Test', :grade => 1)
      s.must_be :valid?
      p.must_be :valid?
      s.save
      p.save
      p.activate

      psl = subject.new
      psl.link({:school => s, :person => p })
      psl.must_be :valid?
      psl.save
      s1 = School.find(s.id)
      p1 = Student.find(p.id)
      p1.schools.must_include(s)
      s1.students.must_include(p)
    end
    it "won't create duplicate links" do
      s = School.new(:name => "Unit Test School - won't create duplicate links")
      p = Student.new(:first_name => 'Unit', :last_name => 'Test', :grade => 1)
      s.must_be :valid?
      p.must_be :valid?
      s.save
      p.save
      p.activate

      psl = subject.new
      psl.link({:school => s, :person => p })
      psl.must_be :valid?
      psl.save
      pslid = psl.id
      psl = subject.new
      psl.link({:school => s, :person => p })
      psl.wont_be :valid?
      s1 = School.find(s.id)
      p1 = Student.find(p.id)
      p1.schools.must_include(s)
      s1.students.must_include(p)
    end
  end

end
