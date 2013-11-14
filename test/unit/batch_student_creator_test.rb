require_relative '../test_helper_with_rails'

describe BatchStudentCreator do
  let(:bob) do
    { first_name: "Bob", last_name: "Loblaw", user: {username: "lawblog", password: "bobloblaw"}, grade: 6, gender: "Male" }
  end
  let(:leroy) do
    # invalid user
    { first_name: nil, last_name: nil, user: {username: nil, password: nil}, grade: nil, gender: nil }
  end
  subject { BatchStudentCreator.new(student_params) }

  describe "creating a single new student" do
    let(:student_params) { [bob] }

    it "calls ActiveRecord to make a new record" do
      assert_changes(Student, :count, 1) do
        subject.call
      end
    end

    describe "[with bad data]" do
      let(:student_params) { [leroy] }

      it "returns false and its #students instances have activerecord errors" do
        response = subject.call
        response.must_equal false
        subject.students.first.valid?.must_equal false
      end
    end
  end

  describe "creating a few students" do
    describe "when one is invalid" do
      let(:student_params) { [bob, leroy] }

      it "saves neither" do
        assert_changes(Student, :count, 0) do
          subject.call
        end
      end
    end
  end
end
