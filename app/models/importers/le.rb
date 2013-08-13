require_relative './le/schools_importer'
require_relative './le/users_importer'
require_relative './le/classrooms_importer'
require_relative './le/classroom_details_importer'
require_relative './le/points_importer'

module Importers
  class Le
    attr_reader :schools_file_path, :users_file_path, :classrooms_file_path, :classroom_details_file_path, :points_file_path
    def initialize(schools_file_path, users_file_path, classrooms_file_path, classroom_details_file_path, points_file_path)
      @schools_file_path = schools_file_path
      @users_file_path = users_file_path
      @classrooms_file_path = classrooms_file_path
      @classroom_details_file_path = classroom_details_file_path
      @points_file_path = points_file_path
    end

    def call
      schools_importer.call
      users_importer.call
      classrooms_importer.call
      classroom_details_importer.call
      points_importer.call
    end

    def schools_importer
      @schools_importer ||= SchoolsImporter.new(schools_file_path)
    end

    def users_importer
      @users_importer ||= UsersImporter.new(users_file_path)
    end

    def classrooms_importer
      @classrooms_importer ||= ClassroomsImporter.new(classrooms_file_path)
    end

    def classroom_details_importer
      @classroom_details_importer ||= ClassroomDetailsImporter.new(classroom_details_file_path)
    end

    def points_importer
      @points_importer ||= PointsImporter.new(points_file_path)
    end
  end
end
