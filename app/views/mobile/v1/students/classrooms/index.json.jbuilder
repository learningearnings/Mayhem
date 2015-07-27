json.array! @classrooms do |classroom|
  	json.(classroom, :id, :name)

	json.goals classroom.classroom_otu_code_categories do |otu_code_category_link|
		json.id otu_code_category_link.otu_code_category.id
		json.name otu_code_category_link.otu_code_category.name
		json.value otu_code_category_link.value
	end

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

	json.checking_history @checking_history.each do |amount|
	    json.id amount.transaction_id
	    json.description amount.transaction.description
	    json.type (amount.type.to_s == "Plutus::DebitAmount")?"Debit":"Credit"
	    json.amount amount.amount.to_i
	end	
	
	json.credits @credits.each do |amount|
	    json.id amount.transaction_id
	    json.description amount.transaction.description
	    json.type (amount.type.to_s == "Plutus::DebitAmount")?"Debit":"Credit"
	    json.amount amount.amount.to_i
	end	
	
	json.debits @debits.each do |amount|
	    json.id amount.transaction_id
	    json.description amount.transaction.description
	    json.type (amount.type.to_s == "Plutus::DebitAmount")?"Debit":"Credit"
	    json.amount amount.amount.to_i
	end	
	
	json.total_debits @debit_balance
	json.total_credits @credit_balance	
	
	json.balance current_person.main_account(current_school).balance

    json.rewards_count classroom.products.count
end  
