require_relative '../../../test_helper'
require_relative '../../../../app/models/importers/sti/schools_importer'

class State; end
class School; end

describe Importers::Sti::SchoolsImporter do
  let(:file_path){ File.expand_path("../../../../support/files/Schools.xml", __FILE__) }
  let(:mock_state_id){ 1 }
  let(:fake_school){ Object.new }
  let(:fake_state){ Object.new }
  subject { Importers::Sti::SchoolsImporter.new(file_path.to_s) }

  before do
    State.stubs(:find_by_abbr).with("MO").returns(fake_state)
  end

  it "takes a filename as its only argument" do
    subject.file_path.must_equal file_path.to_s
  end

  it "creates a school for each element in the file if it doesn't already exist" do
    School.stubs(:where).returns([])
    School.expects(:create).with( name: "Washington High School", sti_uuid: "2077D700-1FCE-4C55-A8F9-B91F4FACAC70", address1: "123 High School Circle", address2: "Attn-  School Office", city: "Hometown", state: fake_state, zip: "55555")
    subject.call
  end

  it "doesn't create the school if one already exists with that uuid" do
    School.stubs(:where).with(sti_uuid: "2077D700-1FCE-4C55-A8F9-B91F4FACAC70").returns([fake_school])
    subject.call
  end
end
