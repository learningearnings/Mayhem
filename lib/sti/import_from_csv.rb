module STI
  class ImportFromCsv
    def initialize filename
      @csv = CSV.parse(File.read(filename))
      @csv.reverse!.pop if @csv.first.first == "school_id"
    end

    def run!
      school_rows_from_csv.each do |school_row|
        school = School.find(school_row.first)
        school.update_attributes :district_guid => school_row.second, :sti_id => school_row.third
      end
      person_rows_from_csv.each do |person_row|
        person = Person.find(person_row.first)
        person.update_attributes :district_guid => person_row.second, :sti_id => person_row.third
      end
    end

    def person_rows_from_csv
      @csv.map {|row| [row[1], row[2], row[4]] }
    end

    def school_rows_from_csv
      @csv.map {|row| [row[0], row[2], row[3]] }.uniq
    end
  end
end
