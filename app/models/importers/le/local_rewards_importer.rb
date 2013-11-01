require_relative './base_importer'

# NOTE: This importer assumes there is a directory at /tmp/le_images, with a structure like:
#
#    $ tree -d /tmp/le_images
#    /tmp/le_images
#    └── images
#        ├── localrewards
#        └── rewardimage
#            └── certificates
#
# To test it out:
#
# i = Importers::Le::LocalRewardsImporter.new("/home/jadams/Downloads/accurate_local_rewards_FINAL_smaller.csv")
# i.call

module Importers
  class Le
    class LocalRewardsImporter < BaseImporter
      protected
      def run
        find_or_create_local_rewards_category
        merged_local_rewards_data.each do |datum|
          execute_teachers_reward_on(datum.except(:id))
        end
      end

      def execute_teachers_reward_on(datum)
        school_id = datum.delete(:school_id)
        teacher_id = datum.delete(:teacher_id)
        image_path = datum.delete(:image_path)
        legacy_reward_local_id = datum.delete(:legacy_reward_local_id)
        rwd = Teachers::Reward.new(datum)
        rwd.school = existing_school(school_id)
        rwd.teacher = existing_teacher(teacher_id)
        rwd.image = image_for(image_path)
        rwd.save
        rwd.set_property("legacy_reward_local_id", legacy_reward_local_id)
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
            legacy_reward_local_id: reward["reward_local_id"],
            name: reward["name"],
            description: reward["desc"],
            category: category_id_for(reward["category"]),
            on_hand: reward["quantity"],
            classrooms: [classroom_id_for(reward["classroom_id"])].compact,
            school_id: reward["school_id"],
            teacher_id: reward["teacher_id"],
            image_path: reward["image_path"],
            min_grade: reward["min_grade"],
            max_grade: reward["max_grade"],
            price: reward["points"]
          }
        end
      end

      def category_id_for(category_name)
        @category.id # We're just putting them all in one category...
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

      def find_or_create_local_rewards_category
        taxonomy = Spree::Taxonomy.where(name: "Categories").first
        @category = taxonomy.taxons.find_or_create_by_name("My Local Rewards")
      end

      def images_directory
        "/tmp/le_images/"
      end

      def image_for(image_path)
        File.open(images_directory + image_path)
      end
    end
  end
end
