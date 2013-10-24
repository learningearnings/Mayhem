require_relative './base_importer'

module Importers
  class Le
    class OTUCodeImporter < BaseImporter
      protected
      def run
        otu_code_data.each do |datum|
          next if datum[:legacy_user_id] == "0" # A lot of these are 0 I'm not sure what to do with those
            person = existing_person(datum[:legacy_user_id])
            classroom = existing_classroom(datum[:legacy_classroom_id])
            school = existing_school(datum[:legacy_school_id])
            person_school_link = person.person_school_links.where(:school_id => school.id).first
            otu_code = OtuCode.new
            otu_code.code = datum[[:code]]
            otu_code.person_school_link = person_school_link
            otu_code.points = datum[:points]
            otu_code.expires_at = datum[:expires_at]
            otu_code.ebuck = datum[:ebuck]
            otu_code.save!
            print "."
        end
      end

      def otu_code_data
        parsed_doc.map do |otu_code|
          {
             code: otu_code["OTUcode"],
             points: otu_code["otucodepoint"],
             expires_at: otu_code["OTUcodeexpires"],
             ebuck: otu_code["ebuck"] == "1" ? true : false,
             legacy_user_id: otu_code["issuinguserID"],
             legacy_school_id: otu_code["schoolID"],
          }
        end
      end

      def existing_person(id)
        Person.where(:legacy_user_id => id).first
      end

      def existing_school(id)
        School.where(:legacy_school_id => id).first
      end

      def existing_classroom(uuid)
        Classroom.where(legacy_classroom_id: uuid).first
      end
    end
  end
end
