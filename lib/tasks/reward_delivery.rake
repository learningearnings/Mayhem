require 'csv'
namespace :reward_delivery do
  desc "Generate reward delivery record if not found for the associated transactions_orders for Student reward purchase."
  task :generate_reward_delivery => :environment do
    reward_deliveries = []
    i = 0
    ## Assign School here
    school_name = ""
    ## Assign from Order created date 
    from_date = "2016-05-17 00:00:00.000000"
    ## Assign to order created date
    to_date = "2016-05-20 00:00:00.000000"
    puts "School name ===> #{school_name}"
    puts "From date   ===> #{from_date}"
    puts "To date     ===> #{to_date}"
    ## Fetch only those orders which have associated transaction_order entries for specified school and date range.
    transaction_orders = TransactionOrder.joins(order: [user: [person: [person_school_links: :school]]]).where("spree_orders.created_at >= '#{from_date}' and spree_orders.created_at < '#{to_date}'")
    transaction_orders.each do |transaction_order|
      ## Get order line items
      line_items = transaction_order.order.line_items
      line_item = line_items.last
      ## check if line_items have associated reward_delivery entry
      reward_delivery = line_items.joins(:reward_delivery)
      ## If line item does not have associated reward delivery create those entires
      if reward_delivery.blank?
        ## Assign Reward creator as from person
        if line_item.product.person.present?
          from_id = line_item.product.person.id
        ## If reward creator is not present assign first ditributor teacher of the school
        else
          from_id = transaction_order.order.user.person_school_links.last.school.distributing_teachers.first.id
        end
        reward_id = line_item.id
        to_id = transaction_order.order.user.person.id
        puts "---------------------------------------------------------------------------------------------"
        puts i = i+1
        puts "Creating Reward Delivery record #{i}."
        ## Create missing reward delivery record
        reward_delivery = RewardDelivery.create(from_id: from_id, to_id: to_id, reward_id: reward_id)
        reward_delivery.created_at = transaction_order.order.created_at
        reward_delivery.updated_at = transaction_order.order.updated_at
        reward_delivery.save
        reward_deliveries << reward_delivery.id
      end  
    end
    puts "--------------------------------------------------------------------------------------------"
    puts "Printing final array of created reward ids."
    puts reward_deliveries.to_s
    export_to_csv(reward_deliveries,school_name) 
  end

  ##Save newly created reward delivery ids to csv file into the public folder.
  def export_to_csv(reward_deliveries,school_name)
    if !school_name.present?
      school_name = "For all Schools till date"
    end  
    file_name = "#{school_name.parameterize.underscore}_reward_delivery_#{Time.now.strftime('%Y-%m-%d_%H-%M-%S')}.csv"
    CSV.open("/home/deployer/reward_deliveries_csv/#{file_name}", "wb") do |csv|
    #CSV.open("public/#{file_name}", "wb") do |csv|
      csv << ["id"]
     	reward_deliveries.each do |r|
     		csv << [r]
     		puts "Adding Created Reward Deliveries into the CSV."
     	end
     	puts "Created #{file_name} file in public folder."
    end	
  end
end

