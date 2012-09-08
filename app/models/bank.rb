require 'action_view'
require 'active_support/core_ext'

class Bank 
  attr_accessor :on_failure, :on_success
  include ActionView::Helpers::UrlHelper

  def initialize(credit_manager=CreditManager.new)
    @credit_manager = credit_manager
    @buck_printer = BuckPrinter.new
    # Set up no-op callbacks in case we don't want to use them
    @on_failure = lambda{}
    @on_success = lambda{}
  end

  def create_print_bucks(person, school, prefix, bucks={})
    points  = amount_of_bucks(bucks)
    account = person.main_account(school)
    return on_failure.call unless account_has_enough_money_for(account, points)
    
    # creates and returns bucks array
    _bucks = create_bucks(person, school, prefix, bucks)

    # add to batch
    bb = BuckBatch.create(:name => 'Test')
    _bucks.map{|x| BuckBatchLink.create(:buck_batch_id => bb.id, :otu_code_id => x.id)}

    @credit_manager.purchase_printed_bucks(school, person, points, bb)
    return on_success.call
  end

  def create_ebucks(person, school, student, prefix, points)
    account = person.main_account(school)
    return @on_failure.call unless account_has_enough_money_for(account, points)

    buck_params = {:person_school_link_id => person_school_link(person, school).id,
                   :expires_at => (Time.now + 45.days), 
                   :student_id => student.id,
                   :ebuck => true}
    buck = create_buck(prefix, points, buck_params)
    @credit_manager.purchase_ebucks(school, person, student, points)

    # NOTE: This message sending isn't really the bank's responsibility imo, but i'll
    # leave it here for now - ja
    send_message(person, student, buck)

    return on_success.call
  end

  # FIXME: Looks like you can claim these twice - that's handled in the
  # controller but I don't think it belongs there
  # FIXME: This doesn't sound like a responsibility of the bank
  def claim_bucks(student, otu_code)
    if otu_code.is_ebuck?
      @credit_manager.issue_ecredits_to_student(otu_code.school, otu_code.teacher, student, otu_code.points)
      application
    else
      @credit_manager.issue_print_credits_to_student(otu_code.school, otu_code.teacher, student, otu_code.points)
    end
    otu_code.update_attribute(:active, false)
  end

  protected
  def buck_creator
    lambda do |params|
      OtuCode.create(params)
    end
  end

  def message_creator
    lambda do |params|
      Message.create params
    end
  end

  def send_message(person, student, buck)
    body = "Click here to claim your award: #{link_to 'Claim Bucks', ("/redeem_bucks?student_id=#{student.id}&code=#{buck.code}")}"

    message_creator.call(from: person,
                         to: student,
                         subject: "You've been awarded LE Bucks", 
                         body: body,
                         category: 'teacher')
  end

  def create_buck(prefix, points, params)
    buck = buck_creator.call(params.merge(:points => BigDecimal.new(points)))
    buck.generate_code(prefix)
    buck
  end

  def person_school_link(person, school)
    person.person_school_links.where(school_id: school.id).first
  end

  def create_bucks(person, school, prefix, bucks)
    buck_params = {:person_school_link_id => person_school_link(person, school).id,
                   :expires_at => (Time.now + 45.days) }
    _bucks = []
    bucks[:ones].times do
      _bucks << create_buck(prefix, 1, buck_params)
    end
    bucks[:fives].times do
      _bucks << create_buck(prefix, 5, buck_params)
    end
    bucks[:tens].times do
      _bucks << create_buck(prefix, 10, buck_params)
    end
   
    # FIX ME 
    #
    #@buck_printer.print_bucks(_bucks)

    _bucks
  end

  def amount_of_bucks(bucks)
    bucks[:ones] + (bucks[:fives] * 5) + (bucks[:tens] * 10)
  end

  def account_has_enough_money_for(account, amount)
    account.balance >= amount
  end
end
