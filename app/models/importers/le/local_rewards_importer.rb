require_relative './base_importer'

module Importers
  class Le
    class LocalRewardsImporter < BaseImporter
      protected
      def run
        @temp_image = File.open(Rails.root.join("public/image_not_found.jpg"))
        merged_local_rewards_data.each do |datum|
          execute_teachers_reward_on(datum.except(:id))
        end
      end

      def execute_teachers_reward_on(datum)
        school_id = datum.delete(:school_id)
        teacher_id = datum.delete(:teacher_id)
        rwd = Teachers::Reward.new(datum)
        rwd.school = existing_school(school_id)
        rwd.teacher = existing_teacher(teacher_id)
        rwd.image = @temp_image
        rwd.save
      end

      def merged_local_rewards_data
        output = []
        local_rewards_data.each do |reward|
          existing_record = output.detect{|r| r[:id] == reward[:id] }
          if(existing_record)
            existing_record[:classrooms] = existing_record[:classrooms] + reward[:classrooms]
          else
            output << reward
          end
        end
        output
      end

      def local_rewards_data
        parsed_doc.map do |reward|
          {
            id: reward["reward_id"],
            name: reward["reward"],
            category: category_id_for(reward["category"]),
            on_hand: reward["quantity"],
            classrooms: [classroom_id_for(reward["classroom_id"])].compact,
            school_id: reward["school_id"],
            teacher_id: reward["teacher_id"],
            price: reward["points"]
          }
        end
      end

      def category_id_for(category_name)
        1
      end

      def classroom_id_for(legacy_classroom_id)
        existing_classroom(legacy_classroom_id).id rescue nil
      end

      def existing_classroom(legacy_classroom_id)
        Classroom.where(legacy_classroom_id: legacy_classroom_id).first
      end

      def existing_school(legacy_school_id)
        School.where(legacy_school_id: legacy_school_id).first
      end

      def existing_teacher(legacy_teacher_id)
        Person.where(legacy_user_id: legacy_teacher_id).first
      end
    end
  end
end
