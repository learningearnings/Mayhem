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
      if charge_person(money, credit_card, options)
        ActiveMerchant::Billing::Response.new(true, 'LE Gateway: Forced success', {}, :test => test?, :authorization => '12345', :avs_result => { :code => 'A' })
      else
        ActiveMerchant::Billing::Response.new(false, 'LE Gateway: Forced failure', :message => 'LE Gateway: Forced Failure', :test => test?)
      end
    end

    def purchase(money, credit_card, options = {})
      if charge_person(money, credit_card, options)
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
    def charge_person(money, credit_card, options)
      person = AccountPersonMapper.new(credit_card.number).find_person
      cm = CreditManager.new
      cm.transfer_credits_for_reward_purchase(person, money/BigDecimal('100.0'))
    end
  end
end
