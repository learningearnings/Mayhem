require_relative './base_importer'

module Importers
  class Le
    class LocalRewardsImporter < BaseImporter
      protected
      def run
        merged_local_rewards_data.each do |datum|
          execute_teachers_reward_on(datum.except(:id))
        end
      end

      def execute_teachers_reward_on(datum)
        rwd = Teachers::Reward.new(datum)
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
            classrooms: [classroom_id_for(reward["classroom_id"])]
          }
        end
      end

      def category_id_for(category_name)
        1
      end

      def classroom_id_for(legacy_classroom_id)
        existing_classroom(legacy_classroom_id).id
      end

      def existing_classroom(legacy_classroom_id)
        Classroom.where(legacy_classroom_id: legacy_classroom_id).first
      end
    end
  end
end
