require 'test_helper'

describe Person do
  subject { Student }

  it "has the basics down" do
    subject.must_be_kind_of Class
  end

  describe "Validations" do

    it "respects coppa rules" do
      p = subject.create(first_name: 'TestFirst', last_name: 'TestLast', grade: 9)
      p.last_name.must_equal 'TestLast'
      p.grade = 6
      p.save
      p.last_name.must_equal 'T'
      p.user.email.must_equal 'test_first_test_last@example.com'
    end

  end

end
