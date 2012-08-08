require_relative '../test_helper'
describe Address do
  subject { Address }

  describe 'validations' do
    it 'validates on zip codes correctly' do
      a = subject.new
      a.zip = 'fooooo'
      a.wont_be :valid?
      a.zip = '35205'
      a.must_be :valid?
    end
  end

end
