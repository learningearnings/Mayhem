require_relative '../../../test_helper'
require_relative '../../../../app/models/importers/sti/rosters_importer'

# This is a stupid mock class so I don't have to depend on activerecord
class Classroom
  def self.create(options)
    @@data[key_for_options(options)] ||= fake_classroom
  end

  def self.where(options)
    [@@data[key_for_options(options)]].compact
  end

  def self.fake_classroom
    object = Object.new
    object.stubs(:assign_owner)
    object
  end

  def self.key_for_options(options)
    options["sti_uuid"]
  end

  def self.clear_data
    @@data = {}
  end
end
class School; end
class Teacher; end
class Student; end

describe Importers::Sti::RostersImporter do
  subject { Importers::Sti::RostersImporter.new(file_path.to_s) }

  let(:file_path){ File.expand_path("../../../../support/files/sti/Rosters.xml", __FILE__) }
  let(:mock_state_id){ 1 }
  let(:fake_school){ Object.new }
  let(:fake_teacher){ Object.new }
  let(:fake_classroom){ Object.new }
  let(:fake_student1){ Object.new }
  let(:fake_student2){ Object.new }

  before do
    Classroom.clear_data
    School.stubs(:where).returns([fake_school])
    Teacher.stubs(:where).with(sti_uuid: "staffguid1").returns([fake_teacher])
    Student.stubs(:where).with(sti_uuid: "studentguid1").returns([fake_student1])
    Student.stubs(:where).with(sti_uuid: "studentguid2").returns([fake_student2])
    fake_student1.stubs(:<<)
    fake_student2.stubs(:<<)
    fake_classroom.stubs(:assign_owner)
    fake_school.stubs(:id).returns(2)
  end

  it "takes a filename as its only argument" do
    subject.file_path.must_equal file_path.to_s
  end

  it "creates a classroom for each classroom in the file unless it already exists" do
    subject.call
    Classroom.where(sti_uuid: "0612.01").first.wont_be_nil
  end

  it "associates the classroom with the appropriate teacher" do
    Classroom.stubs(:create).returns(fake_classroom)
    fake_classroom.expects(:assign_owner).with(fake_teacher)
    subject.call
  end

  it "adds the students to the classroom" do
    Classroom.stubs(:create).returns(fake_classroom)
    fake_student1.expects(:<<).with(fake_classroom)
    fake_student2.expects(:<<).with(fake_classroom)
    subject.call
  end
end
