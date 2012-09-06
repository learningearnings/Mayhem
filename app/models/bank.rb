require 'action_view'
require 'active_support/core_ext'

class Bank 
  attr_accessor :on_failure, :on_success
  include ActionView::Helpers::UrlHelper

  def initialize(credit_manager=CreditManager.new)
    @credit_manager = credit_manager
  end

  def create_print_bucks(person, school, prefix, bucks={})
    points  = amount_of_bucks(bucks)
    account = person.main_account(school)
    return on_failure.call unless account_has_enough_money_for(account, points)

    create_bucks(person, school, prefix, bucks)
    @credit_manager.purchase_printed_bucks(school, person, points)
    return on_success.call
  end

  def create_ebucks(person, school, student, prefix, points)
    account = person.main_account(school)
    return @on_failure.call unless account_has_enough_money_for(account, points)

    buck_params = {:person_school_link => person_school_link(person, school),
                   :expires_at => (Time.now + 45.days), 
                   :student => student, 
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

  def send_message(person, student, buck)
    body = "Click here to claim your award: #{link_to 'Claim Bucks', ("/redeem_bucks?student_id=#{student.id}&code=#{buck.code}")}"

    message_creator(from: person, 
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
    person.person_school_links.where(school: school).first
  end

  def create_bucks(person, school, prefix, bucks)
    buck_params = {:person_school_link => person_school_link(person, school),
                   :expires_at => (Time.now + 45.days) }
    bucks[:ones].times do
      create_buck(prefix, 1, buck_params)
    end
    bucks[:fives].times do
      create_buck(prefix, 5, buck_params)
    end
    bucks[:tens].times do
      create_buck(prefix, 10, buck_params)
    end
  end

  def amount_of_bucks(bucks)
    bucks[:ones] + (bucks[:fives] * 5) + (bucks[:tens] * 10)
  end

  def account_has_enough_money_for(account, amount)
    account.balance >= amount
  end
end
