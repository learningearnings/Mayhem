require 'test_helper_with_rails'

describe Address do
  subject { Address.new }

  describe 'validations' do
    it 'validates on zip codes correctly' do
      subject.wont have_valid(:zip).when('foooo')
      subject.must have_valid(:zip).when('35205')
    end
  end
end
