json.checking_history @recent_checking_amounts do |amount|
    json.id amount.transaction_id
    json.name commercial_document_name(amount.transaction)
    json.date l(amount.transaction.created_at)
    json.description amount.transaction.description
    json.type (amount.type.to_s == "Plutus::DebitAmount")?"Debit":"Credit"
    json.amount number_with_precision(amount.amount, :precision => 2)
    json.source source_from_transaction(amount)
end	

json.savings_history @recent_savings_amounts do |amount|  
    json.id amount.transaction_id
    json.name commercial_document_name(amount.transaction)
    json.date l(amount.transaction.created_at)
    json.description amount.transaction.description
    json.type (amount.type.to_s == "Plutus::DebitAmount")?"Debit":"Credit"
    json.amount number_with_precision(amount.amount, :precision => 2)
    json.source source_from_transaction(amount)
end		

json.ecredits_to_deposit @unredeemed_bucks do | buck |
    json.code buck.code
	json.source buck.source_string
    json.date buck.created_at.strftime("%m-%d-%Y %I:%M %P")
    json.reason buck.otu_code_category ? buck.otu_code_category.name : "N/A"
    json.amount number_with_precision(buck.points, precision: 2, delimiter: ',')
end 

json.checking_balance number_with_precision(@checking_balance, precision: 2, delimiter: ',')
json.savings_balance number_with_precision(@savings_balance, precision: 2, delimiter: ',')
json.products @products do | product |
	if product.deleted?
  		next
    end
    if product.classrooms.any? and (@classrooms & product.classrooms).empty?
	    next
    end
    json.id product.id
    json.name product.name
    json.description product.description
    json.on_hand product.on_hand
    json.price ('%.2f' % product.price)
    json.thumb product.thumb
    json.reward_type ( product.classrooms.any? ? "Classroom" : "School" )
    json.teacher ( product.person ? product.person.id : "" )
end

json.classrooms @classrooms do |classroom|
  	json.(classroom, :id, :name)
	json.rewards classroom.products do |product|
	  	if product.deleted?
	  		next
	    end
	    json.id product.id
	    json.name product.name
	    json.description product.description
	    json.on_hand product.on_hand
	    json.price product.price
	end
    json.rewards_count classroom.products.count
end  
