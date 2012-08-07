require_relative '../test_helper'
=begin
describe Address do
  before do
    @address = FactoryGirl.build :address
  end

  it "has a description" do
    @address.address1.must_equal '123 Street'
  end
end
=end
