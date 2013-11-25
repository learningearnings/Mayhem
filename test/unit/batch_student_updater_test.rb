require_relative '../test_helper_with_rails'

describe BatchStudentUpdater do
  let(:bob_student) { FactoryGirl.create(:student, first_name: "Robert") }
  let(:sally_student) { FactoryGirl.create(:student) }
  let(:leroy_student) { FactoryGirl.create(:student) }
  let(:bob) do
    # NOTE: Keep grade above 6 or last name gets truncated
    { id: bob_student.id, first_name: "Bob", last_name: "Loblaw", user: { username: "lawblog", password: "bobloblaw" }, grade: 9, gender: "Male" }
  end
  let(:sally) do
    # NOTE: Keep grade above 6 or last name gets truncated
    { id: sally_student.id, first_name: "Sally", last_name: "Digieridoo", user: { username: "sally", password: "digeridoo" }, grade: 9, gender: "Female" }
  end
  let(:leroy) do
    # invalid user
    { id: leroy_student.id, first_name: nil, last_name: nil, user: { username: nil, password: nil }, grade: nil, gender: nil }
  end
  let(:school) { FactoryGirl.create(:school) }
  subject { BatchStudentUpdater.new(student_params, school) }

  describe "updating a single student" do
    let(:student_params) { [bob] }

    # NOTE: We aren't testing the user update here, because we aren't going to
    # allow editing the username and the password we won't get back from the db
    # (obviously)
    it "updates the corresponding record" do
      subject.call
      student = Student.find(bob_student.id)
      student_attributes = student.attributes.keep_if{|k,_| bob.keys.include?(k.to_sym) }
      student_attributes.symbolize_keys.must_equal(bob)
    end
  end

  describe "updating multiple students" do
    let(:student_params) { [bob, sally] }

    it "updates the corresponding records" do
      subject.call
      student = Student.find(bob_student.id)
      student_attributes = student.attributes.keep_if{|k,_| bob.keys.include?(k.to_sym) }
      student_attributes.symbolize_keys.must_equal(bob)
      student2 = Student.find(sally_student.id)
      student2_attributes = student2.attributes.keep_if{|k,_| sally.keys.include?(k.to_sym) }
      student2_attributes.symbolize_keys.must_equal(sally)
    end

    describe "with invalid updates" do
      let(:student_params) { [bob, leroy] }

      it "updates no one" do
        subject.call
        student = Student.find(bob_student.id)
        student.first_name.wont_equal("Bob")
      end
    end
  end
end
