require 'test_helper_with_rails'

describe Address do
  subject { Address.new }

  describe 'validations' do
    it 'validates on zip codes correctly' do
      subject.wont have_valid(:zip).when('foooo')
      subject.must have_valid(:zip).when('35205')
    end
  end

  describe "#city_and_state" do
    let(:state){ FactoryGirl.create(:state, name: "BROTOWN", abbr: "BR") }

    it "prints a string representation" do
      Address.new(city: "Foo", state: state).city_and_state.must_equal "Foo, BR"
    end
  end
end
