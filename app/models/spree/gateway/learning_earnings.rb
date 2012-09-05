module Spree
  class Gateway::LearningEarnings < Gateway
    attr_accessor :test

    def provider_class
      self.class
    end

    def preferences
      {}
    end

    def authorize(money, credit_card, options = {})
      if charge_account(money, credit_card, options)
        ActiveMerchant::Billing::Response.new(true, 'LE Gateway: Forced success', {}, :test => test?, :authorization => '12345', :avs_result => { :code => 'A' })
      else
        ActiveMerchant::Billing::Response.new(false, 'LE Gateway: Forced failure', :message => 'LE Gateway: Forced Failure', :test => test?)
      end
    end

    def purchase(money, credit_card, options = {})
      if charge_account(money, credit_card, options)
        ActiveMerchant::Billing::Response.new(true, 'LE Gateway: Forced success', {}, :test => test?, :authorization => '12345', :avs_result => { :code => 'A' })
      else
        ActiveMerchant::Billing::Response.new(false, 'LE Gateway: Forced failure', :message => 'LE Gateway: Forced Failure', :test => test?)
      end
    end

    def credit(money, credit_card, response_code, options = {})
      ActiveMerchant::Billing::Response.new(true, 'LE Gateway: Forced success', {}, :test => test?, :authorization => '12345')
    end

    def capture(authorization, credit_card, gateway_options)
      ActiveMerchant::Billing::Response.new(true, 'LE Gateway: Forced success', {}, :test => test?, :authorization => '67890')
    end

    def void(response_code, credit_card, options = {})
      ActiveMerchant::Billing::Response.new(true, 'LE Gateway: Forced success', {}, :test => test?, :authorization => '12345')
    end

    def test?
      @test == true
    end

    def payment_profiles_supported?
      false
    end

    def actions
      %w(capture void credit)
    end

    private
    def charge_account(money, credit_card, options)
      cm = CreditManager.new
      o = Spree::Order.find_by_number(options[:order_id])
      if o.store == Spree::Store.find_by_name("le")
        # TODO change this to school session variable
        # NOTE: Nope, a model shouldn't know about a session -ja
        school = AccountPersonMapper.new(credit_card.number).find_school
        cm.transfer_store_credits_for_wholesale_purchase(school, money/BigDecimal('100.0'))
      else
        # TODO: This needs to bubble up any errors that it can
        person = AccountPersonMapper.new(credit_card.number).find_person
        cm.transfer_credits_for_reward_purchase(person, money/BigDecimal('100.0'))
      end
    end
  end
end
