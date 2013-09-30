require_relative '../../../test_helper'
require_relative '../../../../app/models/importers/sti/people_importer'

class Person; end
class School; end

describe Importers::Sti::PeopleImporter do
  let(:file_path){ File.expand_path("../../../../support/files/sti/Persons.xml", __FILE__) }
  let(:fake_person){ Object.new }
  let(:fake_school){ Object.new }
  subject { Importers::Sti::PeopleImporter.new(file_path.to_s) }

  before do
    fake_person.stubs(:<<)
    School.stubs(:where).returns([fake_school])
  end

  it "takes a filename as its only argument" do
    subject.file_path.must_equal file_path.to_s
  end

  it "creates a person for each element in the file if it doesn't already exist" do
    Person.stubs(:where).returns([])
    Person.expects(:create).with(first_name: "Gary", last_name: "Adams", grade: 7, type: "Student", sti_uuid: "personguid1", gender: "M").returns(fake_person)
    subject.call
  end

  it "doesn't create the person if one already exists with that uuid" do
    Person.stubs(:where).with(sti_uuid: "personguid1").returns([fake_person])
    subject.call
  end

  it "associates the person with the school" do
    Person.stubs(:where).returns([])
    Person.stubs(:create).returns(fake_person)
    fake_person.expects(:<<).with(fake_school)
    subject.call
  end
end
