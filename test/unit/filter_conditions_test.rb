require 'test_helper_with_rails'

describe FilterConditions do
  subject { FilterConditions }

  it "has the basics down" do
    subject.must_be_kind_of Class
  end

  describe "Operators" do
    it "initializizes correctly" do
      fc = subject.new
      fc.schools.count.must_equal(0)
      fc.classrooms.count.must_equal(0)
      fc.person_classes.count.must_equal(0)
      fc.states.count.must_equal(0)
    end
    it "can be initialized by a hash" do
      fc = subject.new({:schools => [1,2,3], :classrooms => [1,2], :states => [1], :person_classes => ['Student','Teacher','SuperTeacher','LEAdmin']})
      fc.schools.count.must_equal(3)
      fc.classrooms.count.must_equal(2)
      fc.person_classes.count.must_equal(4)
      fc.states.count.must_equal(1)
    end
    it "can receive a School" do
      fc = subject.new
      fc.schools.count.must_equal(0)
      fc << School.new(:id => 1)
      fc.schools.count.must_equal(1)
    end
    it "can receive a hash" do
      fc = subject.new
      fc << {:schools => [1,2,3], :classrooms => [1,2], :states => [1], :person_classes => ['Student','Teacher','SuperTeacher','LEAdmin']}
      fc.schools.count.must_equal(3)
      fc.classrooms.count.must_equal(2)
      fc.person_classes.count.must_equal(4)
      fc.states.count.must_equal(1)
    end
    it "can receive a hash" do
      fc = subject.new
      fc << {:schools => [1,2,3], :classrooms => [1,2], :states => [1], :person_classes => ['Student','Teacher','SuperTeacher','LEAdmin']}
      fc.schools.count.must_equal(3)
      fc.classrooms.count.must_equal(2)
      fc.person_classes.count.must_equal(4)
      fc.states.count.must_equal(1)
    end
    it "can receive a string" do
      fc = subject.new
      fc << 'SuperTeacher'
      fc.person_classes.count.must_equal(1)
      fc.person_classes.must_include 'SuperTeacher'
    end
    it "doesn't store duplicates" do
      fc = subject.new
      fc << {:schools => [1,2,3], :classrooms => [1,2], :states => [1], :person_classes => ['Student','Teacher','SuperTeacher','LEAdmin']}
      fc << {:schools => [3,4], :classrooms => [2,3], :states => [1,2,3,4], :person_classes => ['Student','Teacher','SuperTeacher','SuperLEAdmin']}
      fc.schools.count.must_equal(4)
      fc.classrooms.count.must_equal(3)
      fc.person_classes.count.must_equal(5)
      fc.states.count.must_equal(4)
    end
  end

end


