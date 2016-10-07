require 'action_view'
require 'active_support/core_ext'

class Bank
  attr_accessor :on_failure, :on_success
  include ActionView::Helpers::UrlHelper

  def initialize(credit_manager=CreditManager.new, buck_printer=BuckPrinter.new)
    @credit_manager = credit_manager
    @buck_printer = buck_printer
    # Set up no-op callbacks in case we don't want to use them
    @on_failure = lambda{}
    @on_success = lambda{|batch_id| batch_id}
  end

  def create_person_buck_batch_link(p_school_link, batch)
    PersonBuckBatchLink.create(:person_school_link_id => p_school_link.id, :buck_batch_id => batch.id)
  end

  def create_print_bucks(person, school, prefix, bucks={}, batch)
    points  = amount_of_bucks(bucks)
    account = person.main_account(school)
    return on_failure.call unless account_has_enough_money_for(account, points)

    # creates and returns bucks array
    batch = create_bucks_in_batch(person, school, prefix, bucks, batch)

    @credit_manager.purchase_printed_bucks(school, person, points, batch)
    return on_success.call batch
  end

  def create_ebucks(person, school, student, prefix, points, category_id=nil)
    account = person.main_account(school)
    return @on_failure.call unless account_has_enough_money_for(account, points)

    buck_params = {:person_school_link_id => person_school_link(person, school).id,
                   :expires_at => (Time.now + 90.days),
                   :student_id => student.id,
                   :ebuck => true,
                   :otu_code_category_id => category_id}
    buck = create_buck(prefix, points, buck_params)
    @credit_manager.purchase_ebucks(school, person, student, points, buck)

    # Auto deposit credits for K and 1st grade
    # K is represented by 97,98,99
    if [97,98,99,1,0].include?(student.grade)
      claim_bucks(student, buck)
      ActionController::Base.new.expire_fragment("#{student.id}_balances")
    else
      # NOTE: This message sending isn't really the bank's responsibility imo, but i'll
      # leave it here for now - ja
      send_message(person, student, buck)
    end

    return on_success.call nil
  end

  # FIXME: Looks like you can claim these twice - that's handled in the
  # controller but I don't think it belongs there
  # FIXME: This doesn't sound like a responsibility of the bank
  def claim_bucks(student, otu_code)
    if otu_code.is_ebuck?
      if otu_code.teacher.present?
        @credit_manager.issue_ecredits_to_student(otu_code.school, otu_code.teacher, student, otu_code.points, otu_code)
      else
        @credit_manager.issue_game_credits_to_student(otu_code.source_string, student, otu_code.points, otu_code)
      end
    else
      @credit_manager.issue_print_credits_to_student(otu_code.school, otu_code.teacher, student, otu_code.points, otu_code)
    end
    if otu_code.messages.present?
      otu_code.messages.first.update_attributes(:body => 'You have already claimed these bucks.')
      otu_code.messages.first.hide! rescue nil
    end
    otu_code.update_attribute(:student_id, student.id)
    otu_code.mark_redeemed!
  end

  def transfer_teacher_bucks(school, from_teacher, to_teacher, points)
    account = from_teacher.main_account(school)
    return @on_failure.call unless account_has_enough_money_for(account, points.to_d)

    transaction = @credit_manager.transfer_credits_to_teacher school, from_teacher, to_teacher, points.to_d

    return on_success.call nil
  end

  protected
  def buck_creator
    ->(params) { OtuCode.create params }
  end

  def message_creator(message_params)
    otu_code_id = message_params[:buck_id]
    message_params.delete(:buck_id)

    @message = Message.create(message_params)
    MessageCodeLink.create(:otu_code_id => otu_code_id, :message_id => @message.id)
  end

  def buck_batch_creator
    ->(params) { BuckBatch.create params }
  end

  def buck_batch_link_creator
    ->(params) { BuckBatchLink.create params }
  end

  def send_message(person, student, buck)
    body = "Click here to claim your #{buck.points.to_s} credit(s): #{link_to 'Claim Credits', ("/redeem_bucks?student_id=#{student.id}&code=#{buck.code}")}"

    message_params = {from: person,
                         to: student,
                         subject: "You've been awarded LE Credits",
                         body: body,
                         category: 'teacher',
                         buck_id: buck.id}

    message_creator(message_params)
  end

  def create_buck(prefix, points, params)
    buck = buck_creator.call(params.merge(:points => BigDecimal.new(points)))
    buck
  end

  def person_school_link(person, school)
    person.person_school_links.where(school_id: school.id).first
  end

  def create_bucks(person, school, prefix, bucks)
    buck_params = {:person_school_link_id => person_school_link(person, school).id,
                   :expires_at => (Time.now + 90.days) }
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

    _bucks
  end

  def create_bucks_in_batch(person, school, prefix, bucks, bb)
    _bucks = create_bucks(person, school, prefix, bucks)
    _bucks.map{|x| buck_batch_link_creator.call(:buck_batch_id => bb.id, :otu_code_id => x.id)}
    create_person_buck_batch_link(person_school_link(person, school), bb)
    bb
  end

  def amount_of_bucks(bucks)
    bucks[:ones] + (bucks[:fives] * 5) + (bucks[:tens] * 10)
  end

  def account_has_enough_money_for(account, amount)
    account.balance >= amount
  end
end
