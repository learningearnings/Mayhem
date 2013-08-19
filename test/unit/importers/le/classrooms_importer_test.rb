require_relative '../../../test_helper'
require_relative '../../../../app/models/importers/le/classrooms_importer'

class School; end
class Classroom; end
class Person; end

describe Importers::Le::ClassroomsImporter do
  let(:file_path){ File.expand_path("../../../../support/files/le/classrooms.csv", __FILE__) }
  let(:fake_classroom){ Object.new }
  let(:fake_school){ Object.new }
  let(:fake_teacher){ Object.new }
  let(:fake_person_school_link){ Object.new }
  let(:fake_person_school_classroom_link){ Object.new }
  subject { Importers::Le::ClassroomsImporter.new(file_path.to_s) }

  before do
    fake_school.stubs(:id).returns(2)
    School.stubs(:where).returns([fake_school])
    Person.stubs(:where).returns([fake_teacher])
    Classroom.stubs(:where).returns([])
    Classroom.stubs(:create).returns(fake_classroom)
    fake_classroom.stubs(:assign_owner)
    fake_teacher.stubs(:<<)
    fake_teacher.stubs(:active?).returns(false)
    fake_teacher.stubs(:activate!)
    fake_person_school_link.stubs(:active?).returns(false)
    fake_person_school_classroom_link.stubs(:active?).returns(false)
    fake_person_school_link.stubs(:activate!)
    fake_person_school_classroom_link.stubs(:activate!)
    fake_teacher.stubs(:person_school_links).returns([fake_person_school_link])
    fake_teacher.stubs(:person_school_classroom_links).returns([fake_person_school_classroom_link])
  end

  it "takes a filename as its only argument" do
    subject.file_path.must_equal file_path.to_s
  end

  it "creates a classroom for each element in the file if it doesn't already exist" do
    Classroom.stubs(:where).returns([])
    Classroom.expects(:create).with(name: "Test Classroom", school_id: 2, legacy_classroom_id: "257").returns(fake_classroom)
    subject.call
  end

  it "doesn't create the classroom if one already exists with that uuid" do
    Classroom.stubs(:where).with(legacy_classroom_id: "257").returns([fake_classroom])
    subject.call
  end

  it "creates the teacher ownership link" do
    Classroom.stubs(:where).returns([])
    Classroom.stubs(:create).returns(fake_classroom)
    Person.stubs(:where).with(legacy_user_id: "544").returns([fake_teacher])
    fake_classroom.expects(:assign_owner).with(fake_teacher)
    subject.call
  end

  it "activates the teacher" do
    fake_teacher.expects(:activate!)
    subject.call
  end

  it "activates each school link" do
    fake_person_school_link.expects(:activate!)
    subject.call
  end

  it "activates each classroom link" do
    fake_person_school_classroom_link.expects(:activate!)
    subject.call
  end
end
