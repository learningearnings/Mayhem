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
      Rails.logger.warn("authorizing order")
      Rails.logger.warn money.inspect
      #TODO: Fail if not enough money...
      # Credit card numbers are actually just strings containing the person's account name.  We can then find the account that way.
      person = AccountPersonMapper.new(credit_card).find_person
      cm = CreditManager.new
      cm.transfer_credits_for_reward_purchase(person, money)
      ActiveMerchant::Billing::Response.new(true, 'LE Gateway: Forced success', {}, :test => test?, :authorization => '12345', :avs_result => { :code => 'A' })
    end

    def purchase(money, credit_card, options = {})
      ActiveMerchant::Billing::Response.new(true, 'LE Gateway: Forced success', {}, :test => test?, :authorization => '12345', :avs_result => { :code => 'A' })
    end

    def credit(money, credit_card, response_code, options = {})
      ActiveMerchant::Billing::Response.new(true, 'LE Gateway: Forced success', {}, :test => test?, :authorization => '12345')
    end

    def capture(authorization, credit_card, gateway_options)
      Rails.logger.warn("capturing order")
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
  end
end
