require 'test_helper'

describe FilterFactory do
  subject { FilterFactory }


  it "has the basics down" do
    subject.must_be_kind_of Class
  end

  it "can find the all inclusive filter" do
    ff = FilterFactory.new
    f = ff.find_or_create_filter
    f.wont_be_nil
  end

  it "can create a filter that doesn't exist" do
    school = FactoryGirl.create(:school)
    fc = FilterConditions.new
    fc << school
    ff = FilterFactory.new
    f = ff.find_or_create_filter(fc)
    f.must_be :valid?
#    f.id.wont_equal 1
    f.save
    f.id.wont_be_nil
  end

  it "can create a filter and find it later" do
    school = FactoryGirl.create(:school)
    fc = FilterConditions.new
    fc << school
    ff = FilterFactory.new
    f = ff.find_or_create_filter(fc)
    f.must_be :valid?
    f.wont_be_nil
#    binding.pry
    f1 = ff.find_or_create_filter(fc)
    f.id.must_equal(f1.id)
  end

  it "can find state-only filter membership" do
    state = FactoryGirl.create(:state)
    school = FactoryGirl.create(:school)
    address = FactoryGirl.create(:address, state: state, addressable: school)
    student = FactoryGirl.create(:student)
    link = FactoryGirl.create(:person_school_link, person: student, school: school)
    ff = FilterFactory.new
    fc = FilterConditions.new
    fc << state
    fc.states.must_include state.id
    f = ff.find_or_create_filter(fc)
#    f.id.wont_equal 1
    f.save
    f.id.wont_be_nil
    membership = ff.find_filter_membership(student)
    membership.must_include f
  end

  it "can find school-only filter membership" do
    state = FactoryGirl.create(:state)
    school = FactoryGirl.create(:school)
    address = FactoryGirl.create(:address, state: state, addressable: school)
    student = FactoryGirl.create(:student, grade: 9)
    link = FactoryGirl.create(:person_school_link, person: student, school: school)
    ff = FilterFactory.new
    fc = FilterConditions.new
    fc << school
    fc.schools.must_include school.id
    f = ff.find_or_create_filter(fc)
    f.save
    f.id.wont_be_nil
    f.schools.must_include school
    membership = ff.find_filter_membership(student)
    membership.must_include f
  end

  it "can find person-class-only filter membership" do
    student = FactoryGirl.create(:student, grade: 9)
    teacher = FactoryGirl.create(:teacher, grade: 9)
    ff = FilterFactory.new
    fc = FilterConditions.new
    fc << "Student"
    fc.person_classes.must_include "Student"
    f = ff.find_or_create_filter(fc)
    f.save
    f.id.wont_be_nil
    f.person_classes.must_include "Student"
    membership = ff.find_filter_membership(student)
    membership.must_include f
    membership = ff.find_filter_membership(teacher)
    membership.wont_include f
  end

  it "can find school-classroom filter membership" do
    state = FactoryGirl.create(:state)
    school = FactoryGirl.create(:school)
    address = FactoryGirl.create(:address, state: state, addressable: school)
    student = FactoryGirl.create(:student, grade: 9)
    teacher = FactoryGirl.create(:teacher, grade: 9)
    classroom = FactoryGirl.create(:classroom)
    tlink = FactoryGirl.create(:person_school_link, person: teacher, school: school)
    slink = FactoryGirl.create(:person_school_link, person: student, school: school)
    tclink = FactoryGirl.create(:person_school_classroom_link, person_school_link: tlink, classroom: classroom )
    tslink = FactoryGirl.create(:person_school_classroom_link, person_school_link: slink, classroom: classroom )
    ff = FilterFactory.new
    fc = FilterConditions.new
    fc << classroom
    fc.classrooms.must_include classroom.id
    f = ff.find_or_create_filter(fc)
    f.save
    f.id.wont_be_nil
    f.classrooms.must_include classroom
    membership = ff.find_filter_membership(student)
    membership.must_include f
    membership = ff.find_filter_membership(teacher)
    membership.must_include f
  end

=begin
  it "can find grade filter membership" do
  end
=end
end

