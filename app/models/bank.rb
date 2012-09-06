require 'action_view'
require 'active_support/core_ext'

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
    buck_params = {:person_school_link => person_school_link(person, school),
                   :expires_at => (Time.now + 45.days) }
    buck_array = []
    bucks[:ones].times do
      buck_array << create_buck(prefix, 1, buck_params)
    end
    bucks[:fives].times do
      buck_array << create_buck(prefix, 5, buck_params)
    end
    bucks[:tens].times do
      buck_array << create_buck(prefix, 10, buck_params)
    end
    points = buck_array.map{|x| x.points}.sum
    @credit_manager.purchase_printed_bucks(school, person, points)
    return on_success.call
  end

  def create_ebucks(person, school, student, prefix, points)
    return @on_failure.call if person.main_account(school).balance <= points
    buck_params = {:person_school_link => person_school_link(person, school),
                   :expires_at => (Time.now + 45.days), 
                   :student => student, 
                   :ebuck => true}
    buck = create_buck(prefix, points, buck_params)
    @credit_manager.purchase_ebucks(school, person, student, points)
    message = message_creator(:from => person, 
                             :to => student, 
                             :subject => "You've been awarded LE Bucks", 
                             :body => "Click here to claim your award: #{link_to 'Claim Bucks', ("/redeem_bucks?student_id=#{student.id}&code=#{buck.code}")}",
                             :category => 'teacher')
    return on_success.call
  end

  # FIXME: Looks like you can claim these twice - that's handled in the
  # controller but I don't think it belongs there
  # FIXME: This doesn't sound like a responsibility of the bank
  def claim_bucks(student, otu_code)
    if otu_code.is_ebuck?
      @credit_manager.issue_ecredits_to_student(otu_code.school, otu_code.teacher, student, otu_code.points)
    else
      @credit_manager.issue_print_credits_to_student(otu_code.school, otu_code.teacher, student, otu_code.points)
    end
    otu_code.update_attribute(:active, false)
  end

  protected
  def buck_creator(params)
    lambda do |params|
      OtuCode.create(params)
    end
  end

  def message_creator(params)
    lambda do |params|
      Message.create params
    end
  end

  def create_buck(prefix, points, params)
    buck = buck_creator.call(params.merge(:points => BigDecimal.new(points)))
    buck.generate_code(prefix)
    buck
  end

  def person_school_link(person, school)
    person.person_school_links.where(school: school).first
  end
end
