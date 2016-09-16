json.array! @purchases do |reward_delivery|
   if reward_delivery.to && reward_delivery.reward && reward_delivery.reward.product # Guard against deleted rewards
	   student = reward_delivery.to
	   json.student_id student.id
	   json.student_first_name student.first_name
	   json.student_last_name student.last_name
	   json.student_full_name student.full_name
	   json.student_grade student.grade
	   json.student_gender student.gender
	   json.avatar_url student.avatar.try(:image).try(:url)
	   json.reward_name reward_delivery.reward.product.name
	   json.reward_quantity reward_delivery.reward.quantity
	   json.reward_status reward_delivery.status.humanize
	   json.reward_delivery_id reward_delivery.id
	   json.reward_delivery_status reward_delivery.status
	   json.reward_delivery_created reward_delivery.created_at.to_date.to_s
   end
end
