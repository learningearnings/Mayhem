require 'spec_helper'

describe Address do
  before do
    @address = FactoryGirl.build(:address)
  end
  describe "#geocode_address" do
    it "should provide a correct address for geocoding" do
     expect(@address.geocode_address).to eq("#{@address.line1}, #{@address.city} #{@address.state} #{@address.zip}")
    end
  end

  describe "#city_and_state" do
    it "should provide the correct city and state abbrivation" do
      expect(@address.city_and_state).to eq("#{@address.city}, #{@address.state.abbr}")
    end
  end
end
