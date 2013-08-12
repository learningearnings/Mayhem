require_relative '../../../test_helper'
require_relative '../../../../app/models/importers/sti/schools_importer'

class State; end
class School; end

describe Importers::Sti::SchoolsImporter do
  let(:file_path){ File.expand_path("../../../../support/files/Schools.xml", __FILE__) }
  let(:mock_state_id){ 1 }
  subject { Importers::Sti::SchoolsImporter.new(file_path.to_s) }

  it "takes a filename as its only argument" do
    subject.file_path.must_equal file_path.to_s
  end

  it "creates a school for each element in the file" do
    mock_state = MiniTest::Mock
    State.stubs(:find_by_abbr).with("MO").returns(mock_state)
    School.expects(:create).with( name: "Washington High School", sti_uuid: "2077D700-1FCE-4C55-A8F9-B91F4FACAC70", address1: "123 High School Circle", address2: "Attn-  School Office", city: "Hometown", state: mock_state, zip: "55555")
    subject.call
  end
end
