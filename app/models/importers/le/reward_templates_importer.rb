require 'csv'
require 'logger'
require 'forwardable'


#     i = Importers::Le::RewardTemplatesImporter.new("/home/robby/Desktop/le/rewards-templates.csv", "/home/robby/Desktop/le/reward_templates/")
#     i.call
#
# It expects to be passed a directory where the images whose filenames are
# represented in the master_rewards.csv file can be found.  Should be a string,
# ending in a slash, because I'm lazy.
module Importers
  class Le
    class RewardTemplatesImporter
      extend Forwardable
      def_delegators :@logger, :warn, :info, :debug

      attr_reader :rewards_file_path, :log_file_path, :images_directory
      def initialize(rewards_file_path, images_directory, log_file_path='/tmp/le_importer.log')
        @rewards_file_path = rewards_file_path
        @images_directory = images_directory
        @log_file = File.open(log_file_path, 'a')
        @log_file_path = log_file_path
        @logger = Logger.new(@log_file)
      end

      def call
        begin
          #ActiveRecord::Base.transaction do
            run
          #end
        ensure
          @log_file.close
        end
      end

      protected
      def run
        rewards_data.each do |datum|
          create_template_for(datum)
        end
      end

      def create_template_for(datum)
        reward_template = RewardTemplate.new
        reward_template.name = datum[:name]
        reward_template.min_grade = datum[:min_grade]
        reward_template.max_grade = datum[:max_grade]
        if datum[:image].present?
          reward_template.image = datum[:image]
        end
        reward_template.save
      end

      def rewards_data
        parsed_rewards_doc.map do |reward|
          {
            name: reward["Name"],
            min_grade: reward["Min Grade"],
            max_grade: reward["Max Grade"],
            image: image_for(reward["Image Name"])
          }
        end
      end

      def parsed_rewards_doc
        parsed_doc(rewards_file_data)
      end

      def parsed_doc(file_data)
        CSV.parse(file_data, headers: true)
      end

      def rewards_file_data
        file_data(rewards_file_path)
      end

      def file_data(file_path)
        File.read(file_path).gsub('\"', '""')
      end

      def image_for(image_name)
        begin
          File.open(@images_directory + '/' + image_name)
        rescue
          nil
        end
      end
    end
  end
end
