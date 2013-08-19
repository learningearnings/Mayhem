require_relative '../../../test_helper'
require_relative '../../../../app/models/importers/le/classroom_details_importer'

class Classroom; end
class Person; end

describe Importers::Le::ClassroomDetailsImporter do
  let(:file_path){ File.expand_path("../../../../support/files/le/classroom_details.csv", __FILE__) }
  let(:fake_classroom){ Object.new }
  let(:fake_person){ Object.new }
  let(:fake_person_school_link){ Object.new }
  let(:fake_person_school_classroom_link){ Object.new }
  subject { Importers::Le::ClassroomDetailsImporter.new(file_path.to_s) }

  before do
    fake_person_school_link.stubs(:active?).returns(false)
    fake_person_school_classroom_link.stubs(:active?).returns(false)
    fake_person_school_link.stubs(:activate!)
    fake_person_school_classroom_link.stubs(:activate!)
    fake_person.stubs(:person_school_links).returns([fake_person_school_link])
    fake_person.stubs(:person_school_classroom_links).returns([fake_person_school_classroom_link])
    fake_person.stubs(:<<)
    Person.stubs(:where).with(legacy_user_id: "545").returns([fake_person])
    Classroom.stubs(:where).with(legacy_classroom_id: "257").returns([fake_classroom])
  end

  it "takes a filename as its only argument" do
    subject.file_path.must_equal file_path.to_s
  end

  it "adds each person to the corresponding classroom" do
    fake_person.expects(:<<).with(fake_classroom)
    subject.call
  end

  it "activates the school links" do
    fake_person_school_link.expects(:activate!)
    subject.call
  end

  it "activates the classroom links" do
    fake_person_school_classroom_link.expects(:activate!)
    subject.call
  end
end
