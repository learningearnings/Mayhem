require 'test_helper_with_rails'

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
      p = Student.new(:first_name => 'Unit', :last_name => 'Test', :grade => 1,:user => FactoryGirl.create(:spree_user,:email => 'test_first_test1@example.com'))
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
      p = Student.new(:first_name => 'Unit', :last_name => 'Test', :grade => 1,:user => FactoryGirl.create(:spree_user,:email => 'test_first_test2@example.com'))
      s.must_be :valid?
      p.must_be :valid?
      s.save
      p.save
      p.activate
      s.activate

      psl = subject.new
      psl.link({:school => s, :person => p })
      psl.must_be :valid?
      psl.save
      psl.activate
      s1 = School.find(s.id)
      p1 = Student.find(p.id)
      p1.schools.must_include(s)
      s1.students.must_include(p)
    end

    it "won't create duplicate links" do
      s = School.new(:name => "Unit Test School - won't create duplicate links")
      p = Student.new(:first_name => 'Unit', :last_name => 'Test', :grade => 1,:user => FactoryGirl.create(:spree_user,:email => 'test_first_test3@example.com'))
      s.must_be :valid?
      p.must_be :valid?
      s.save
      p.save
      p.activate
      s.activate

      psl = subject.new
      psl.link({:school => s, :person => p })
      psl.must_be :valid?
      psl.activate
      psl.save
      pslid = psl.id
      psl1 = subject.new
      psl1.link({:school => s, :person => p })
      psl1.wont_be :valid?
      p.reload
      s.reload
      p.schools.must_include(s)
      s.students.must_include(p)
      s.deactivate
      p.deactivate
      p.reload
      s.reload
      p.schools.wont_include(s)
      s.students.wont_include(p)
      p.activate
      s.activate
      psl.deactivate
      psl.save
      p.reload
      s.reload
      p.schools.wont_include(s)
      s.students.wont_include(p)
    end
  end
end
