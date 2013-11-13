require_relative '../test_helper_with_rails'

describe BatchStudentManager do
  describe "creating a single new student" do
    let(:student_params) do
      [
        { first_name: "Bob", last_name: "Loblaw", username: "lawblog", grade: 6, gender: "Male", password: "bobloblaw" }
      ]
    end
    subject { BatchStudentManager.new(student_params) }

    it "calls ActiveRecord to make a new record" do
      assert_changes(Student, :count, 1) do
        subject.call
      end
    end

    describe "[with bad data]" do
      let(:student_params) do
        [
          { first_name: "Bob", last_name: "Loblaw", username: nil, grade: 6, gender: "Male", password: nil }
        ]
      end
      it "returns false and its #students instances have activerecord errors" do
        response = subject.call
        response.must_equal false
        subject.students.first.valid?.must_equal false
      end
    end
  end
end
