module Importers
  class Sti
    attr_reader :schools_file_path, :rosters_file_path, :people_file_path
    def initialize(schools_file_path, rosters_file_path, people_file_path)
      @schools_file_path = schools_file_path
      @rosters_file_path = rosters_file_path
      @people_file_path = people_file_path
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

    class SchoolsImporter
      def initialize(filename)
      end
    end

    class RostersImporter
      def initialize(filename)
      end
    end

    class PeopleImporter
      def initialize(filename)
      end
    end
  end
end
