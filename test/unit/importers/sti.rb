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
end
