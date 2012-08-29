class Bank 

  def initialize(credit_manager=CreditManager.new)
    @credit_manager = credit_manager
  end

  def create_print_bucks(person, prefix, bucks={})
    buck_params = {:person_school_link_id => person.person_school_links.first.id, 
                   :expires_at => (Time.now + 45.days) }
    buck_array = []
    bucks[:ones].times do
      buck_array << OtuCode.create(buck_params.merge :points => BigDecimal.new('1'))
    end
    bucks[:fives].times do
      buck_array << OtuCode.create(buck_params.merge :points => BigDecimal.new('5'))
    end
    bucks[:tens].times do
      buck_array << OtuCode.create(buck_params.merge :points => BigDecimal.new('10'))
    end
    buck_array.map{|x| x.generate_code(prefix)}
    points = buck_array.map{|x| x.points}.sum
    @credit_manager.purchase_printed_bucks(person.schools.first, person, points)
  end

  def create_ebucks(person, student, prefix, points)
    buck_params = {:person_school_link_id => person.person_school_links.first.id, 
                   :expires_at => (Time.now + 45.days), 
                   :student_id => student.id, 
                   :points => BigDecimal.new(points),
                   :ebuck => true}
    buck = OtuCode.create(buck_params)
    buck.generate_code(prefix)
    @credit_manager.purchase_ebucks(person.schools.first, person, student, points)
  end

end
