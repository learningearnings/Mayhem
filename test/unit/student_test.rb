require 'test_helper_with_rails'

describe Student do
  subject { Student }

  it "has the basics down" do
    subject.must_be_kind_of Class
  end

  describe "Validations" do
    it "respects coppa rules" do
      p = subject.create(first_name: 'TestFirst', last_name: 'TestLast', grade: 9,:user => FactoryGirl.create(:spree_user,:email => 'test_first_test_last@example.com'))
      p.last_name.must_equal 'TestLast'
      p.grade = 6
      p.save
      p.last_name.must_equal 'T'
      p.user.email.must_equal 'test_first_test_last@example.com'
    end
  end

  describe "#grademates" do
    before do
      @student1 = FactoryGirl.build(:student, grade: 4)
      @student2 = FactoryGirl.build(:student, grade: 4)
      @student3 = FactoryGirl.build(:student, grade: 5)
      school = mock "school"
      @student1.expects(:school).returns(school)
      students_proxy = mock "students proxy"
      students_proxy.expects(:where).with(grade: 4).returns([@student1, @student2])
      school.expects(:students).returns(students_proxy)
    end

    it "includes the right students" do
      @student1.grademates.must_equal [@student2]
    end
    it "doesn't include the wrong students" do
      @student1.grademates.wont_include(@student3)
    end
  end
end
