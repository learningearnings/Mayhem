class Bank 
  attr_accessor :on_failure, :on_success
  include ActionView::Helpers::UrlHelper

  def initialize(credit_manager=CreditManager.new)
    @credit_manager = credit_manager
  end

  def create_print_bucks(person, school, prefix, bucks={})
    if person.main_account(school).balance <= (bucks[:ones] + (bucks[:fives] * 5) + (bucks[:tens] * 10))
      return on_failure.call
    end
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
    return on_success.call
  end

  def create_ebucks(person, school, student, prefix, points)
    return @on_failure.call if person.main_account(school).balance <= points
    buck_params = {:person_school_link_id => person.person_school_links.first.id, 
                   :expires_at => (Time.now + 45.days), 
                   :student_id => student.id, 
                   :points => BigDecimal.new(points),
                   :ebuck => true}
    buck = OtuCode.create(buck_params)
    buck.generate_code(prefix)
    @credit_manager.purchase_ebucks(person.schools.first, person, student, points)
    message = Message.create(:from_id => person.id, 
                             :to_id => student.id, 
                             :subject => 'You\'ve been awarded LE Bucks', 
                             :body => "Click here to claim your award: #{link_to 'Claim Bucks', ("/redeem_bucks?student_id=#{student.id}&code=#{buck.code}")}")
    return on_success.call
  end

  # FIXME: Looks like you can claim these twice - that's handled in the
  # controller but I don't think it belongs there
  def claim_bucks(student, otu_code)
    if otu_code.is_ebuck?
      @credit_manager.issue_ecredits_to_student(otu_code.school, otu_code.teacher, student, otu_code.points)
    else
      @credit_manager.issue_print_credits_to_student(otu_code.school, otu_code.teacher, student, otu_code.points)
    end
    otu_code.update_attribute(:active, false)
  end
end
