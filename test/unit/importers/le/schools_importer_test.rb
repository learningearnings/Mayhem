require_relative '../../../test_helper'
require_relative '../../../../app/models/importers/le/schools_importer'

class State; end
class School; end

describe Importers::Le::SchoolsImporter do
  let(:file_path){ File.expand_path("../../../../support/files/le/schools.csv", __FILE__) }
  let(:mock_state_id){ 1 }
  let(:fake_school){ Object.new }
  let(:fake_state){ Object.new }
  subject { Importers::Le::SchoolsImporter.new(file_path.to_s) }

  before do
    fake_school.stubs(:activate!)
    fake_state.stubs(:id).returns(3)
    State.stubs(:find_by_name).with("Alabama").returns(fake_state)
  end

  it "takes a filename as its only argument" do
    subject.file_path.must_equal file_path.to_s
  end

  it "creates a school for each element in the file if it doesn't already exist" do
    School.stubs(:where).returns([])
    School.expects(:create).with( name: "Challenger Middle School", min_grade: '6', max_grade: '8', legacy_school_id: "74", address1: "13555 CHANEY THOMPSON RD", address2: "", city: "Huntsville", state_id: 3, zip: "55555", distribution_model: "Distributed", school_phone: nil).returns(fake_school)

    subject.call
  end

  it "doesn't create the school if one already exists with that uuid" do
    School.stubs(:where).with(legacy_school_id: "74").returns([fake_school])
    subject.call
  end

  it "activates the school on import" do
    School.stubs(:where).returns([])
    School.stubs(:create).returns(fake_school)
    fake_school.expects(:activate!)
    subject.call
  end
end
