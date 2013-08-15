require_relative './sti/schools_importer'
require_relative './sti/rosters_importer'
require_relative './sti/people_importer'
module Importers
  class Sti
    attr_reader :schools_file_path, :rosters_file_path, :people_file_path
    def initialize(schools_file_path, rosters_file_path, people_file_path)
      @schools_file_path = schools_file_path
      @rosters_file_path = rosters_file_path
      @people_file_path = people_file_path
    end

    def call
      schools_importer.call
      rosters_importer.call
      people_importer.call
    end

    def schools_importer
      @schools_importer ||= SchoolsImporter.new(schools_file_path)
    end

    def rosters_importer
      @rosters_importer ||= RostersImporter.new(rosters_file_path)
    end

    def people_importer
      @people_importer ||= PeopleImporter.new(people_file_path)
    end
  end
end
