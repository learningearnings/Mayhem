require_relative '../../test_helper'
require_relative '../../../app/models/importers/le'

describe Importers::Le do
  subject { Importers::Le.new("schools", "users", "classrooms", "classroom_details", "points") }

  it "takes five filenames as arguments" do
    subject.schools_file_path.must_equal "schools"
    subject.users_file_path.must_equal "users"
    subject.classrooms_file_path.must_equal "classrooms"
    subject.classroom_details_file_path.must_equal "classroom_details"
    subject.points_file_path.must_equal "points"
  end

  it "instantiates a SchoolsImporter" do
    subject.schools_importer.must_be_instance_of(Importers::Le::SchoolsImporter)
  end

  it "instantiates a UsersImporter" do
    subject.users_importer.must_be_instance_of(Importers::Le::UsersImporter)
  end

  it "instantiates a ClassroomsImporter" do
    subject.classrooms_importer.must_be_instance_of(Importers::Le::ClassroomsImporter)
  end

  it "instantiates a ClassroomDetailsImporter" do
    subject.classroom_details_importer.must_be_instance_of(Importers::Le::ClassroomDetailsImporter)
  end

  it "instantiates a PointsImporter" do
    subject.points_importer.must_be_instance_of(Importers::Le::TeacherPointsImporter)
  end

  it "calls each of its importers when called" do
    mock_schools_importer = MiniTest::Mock.new
    mock_users_importer = MiniTest::Mock.new
    mock_classrooms_importer = MiniTest::Mock.new
    mock_classroom_details_importer = MiniTest::Mock.new
    mock_points_importer = MiniTest::Mock.new
    mock_schools_importer.expect :call, true
    mock_users_importer.expect :call, true
    mock_classrooms_importer.expect :call, true
    mock_classroom_details_importer.expect :call, true
    mock_points_importer.expect :call, true
    Importers::Le::SchoolsImporter.stubs(:new).returns(mock_schools_importer)
    Importers::Le::UsersImporter.stubs(:new).returns(mock_users_importer)
    Importers::Le::ClassroomsImporter.stubs(:new).returns(mock_classrooms_importer)
    Importers::Le::ClassroomDetailsImporter.stubs(:new).returns(mock_classroom_details_importer)
    Importers::Le::TeacherPointsImporter.stubs(:new).returns(mock_points_importer)
    subject.call
    assert mock_schools_importer.verify
    assert mock_users_importer.verify
    assert mock_classrooms_importer.verify
    assert mock_classroom_details_importer.verify
    assert mock_points_importer.verify
  end
end
