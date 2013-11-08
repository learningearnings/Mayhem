require 'csv'
require 'logger'
require 'forwardable'

# MasterRewardsImporter should be run like so:
#
#     i = Importers::Le::MasterRewardsImporter.new("/home/jadams/tmp/master_rewards.csv", "/home/jadams/tmp/rewards_already_shipped_to_schools.csv", "/home/jadams/tmp/rewardimage/")
#     i.call
#
# It expects to be passed a directory where the images whose filenames are
# represented in the master_rewards.csv file can be found.  Should be a string,
# ending in a slash, because I'm lazy.
module Importers
  class Le
    class MasterRewardsImporter
      extend Forwardable
      def_delegators :@logger, :warn, :info, :debug

      attr_reader :rewards_file_path, :shipments_file_path, :log_file_path, :images_directory
      def initialize(rewards_file_path, shipments_file_path, images_directory, log_file_path='/tmp/le_importer.log')
        @rewards_file_path = rewards_file_path
        @shipments_file_path = shipments_file_path
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
        @products = {}
        master_rewards_data.each do |datum|
          create_product_for(datum)
          create_shipments_for(datum[:legacy_id])
        end
      end

      def create_product_for(datum)
        product = Spree::Product.new
        product.name = datum[:name]
        product.price = datum[:price]
        product.description = datum[:description]
        product.on_hand = 10_000 # Just giving a ridiculous number to start with so we have enough on hand to import
        product.available_on = Time.now
        product.store_ids = [master_store.id]
        product.fulfillment_type = 'Shipped for School Inventory'
        product.purchased_by = "LE"
        product.min_grade = datum[:min_grade]
        product.max_grade = datum[:max_grade]
        product.save
        if(datum[:image])
          product.images.create(attachment: datum[:image])
        end
        product.set_property("reward_type", "wholesale")
        product.set_property("legacy_reward_id", datum[:legacy_id])
        @products[datum[:legacy_id]] = product
      end

      def create_shipments_for(legacy_id)
        product = get_product(legacy_id)
        shipments_for_product = shipments_data.select{|shipment| shipment[:legacy_reward_id] == legacy_id }
        shipments_for_product.each do |shipment|
          create_shipment_for(shipment, product)
        end
      end

      def create_shipment_for(shipment_data, master_product)
        command = SchoolStoreProductDistributionCommand.new(
          master_product: master_product,
          school: shipment_data[:school],
          quantity: shipment_data[:quantity],
          retail_price: master_product.price
        )
        command.execute!
      end

      def master_rewards_data
        parsed_rewards_doc.map do |reward|
          {
            legacy_id: reward["reward_id"],
            name: reward["name"],
            description: reward["description"],
            price: reward["credits"],
            image: image_for(reward["image_path"]),
            min_grade: reward["min_grade"],
            max_grade: reward["max_grade"]
          }
        end
      end

      def shipments_data
        parsed_shipments_doc.map do |shipment|
          {
            legacy_reward_id: shipment["reward_id"],
            school: existing_school(shipment["school_id"]),
            quantity: shipment["reward_quantity"]
          }
        end
      end

      def get_product(legacy_reward_id)
        @products[legacy_reward_id]
      end

      def existing_school(legacy_school_id)
        School.where(legacy_school_id: legacy_school_id).first
      end

      def parsed_rewards_doc
        parsed_doc(rewards_file_data)
      end

      def parsed_shipments_doc
        parsed_doc(shipments_file_data)
      end

      def parsed_doc(file_data)
        CSV.parse(file_data, headers: true)
      end

      def rewards_file_data
        file_data(rewards_file_path)
      end

      def shipments_file_data
        file_data(shipments_file_path)
      end

      def file_data(file_path)
        File.read(file_path).gsub('\"', '""')
      end

      def image_for(image_path)
        begin
          File.open(@images_directory + image_path)
        rescue
          nil
        end
      end

      def master_store
        @master_store ||= Spree::Store.find_by_code("le")
      end
    end
  end
end
