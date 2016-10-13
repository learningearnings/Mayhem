module Reports
  class StudentActivity < Activity
    def person_base_scope
      school.students.includes(:user)
    end

	  def transaction_filter
	  	[:where, "plutus_transactions.description ILIKE 'Weekly Credits for%' or plutus_transactions.description ILIKE
                               'Credits Earned for %' or plutus_transactions.description ILIKE 'Monthly Credits for%' or plutus_transactions.description IN
	                             ('Issue Credits to Student','Issue Printed Credits to Student')"]
	  end
  end
end
