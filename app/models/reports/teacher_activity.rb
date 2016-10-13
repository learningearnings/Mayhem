module Reports
  class TeacherActivity < Activity
    def person_base_scope
      school.teachers.includes(:user)
    end

    def transaction_filter
    	[:where, "plutus_amounts.type = 'Plutus::DebitAmount' and plutus_transactions.description IN
                               ('Transfer Credits to Teacher',
                                'Issue Credits to Teacher', 'Issue Monthly Credits to Teacher')"]
    end
  end
end
