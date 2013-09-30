require_relative '../../test_helper'
require_relative '../../../app/models/importers/sti'

describe Importers::Sti do
  subject { Importers::Sti.new("schools", "rosters", "people") }

  it "takes three filenames as arguments" do
    subject.schools_file_path.must_equal "schools"
    subject.rosters_file_path.must_equal "rosters"
    subject.people_file_path.must_equal "people"
  end

  it "instantiates a SchoolsImporter" do
    subject.schools_importer.must_be_instance_of(Importers::Sti::SchoolsImporter)
  end

  it "instantiates a RostersImporter" do
    subject.rosters_importer.must_be_instance_of(Importers::Sti::RostersImporter)
  end

  it "instantiates a PeopleImporter" do
    subject.people_importer.must_be_instance_of(Importers::Sti::PeopleImporter)
  end

  it "calls each of its importers when called" do
    mock_schools_importer = MiniTest::Mock.new
    mock_rosters_importer = MiniTest::Mock.new
    mock_people_importer = MiniTest::Mock.new
    mock_schools_importer.expect :call, true
    mock_rosters_importer.expect :call, true
    mock_people_importer.expect :call, true
    Importers::Sti::SchoolsImporter.stubs(:new).returns(mock_schools_importer)
    Importers::Sti::RostersImporter.stubs(:new).returns(mock_rosters_importer)
    Importers::Sti::PeopleImporter.stubs(:new).returns(mock_people_importer)
    subject.call
    assert mock_schools_importer.verify
    assert mock_rosters_importer.verify
    assert mock_people_importer.verify
  end
end
