require 'test_helper'
require_relative '../../app/models/school_store_product_distribution_command'

describe SchoolStoreProductDistributionCommand do
  subject { SchoolStoreProductDistributionCommand }

  before do

  end

  describe 'validations' do
    it "requires valid parameters" do
      subject.new.wont have_valid(:master_product).when(nil)
      subject.new.wont have_valid(:school).when(nil)
      subject.new.must have_valid(:retail_price).when(1)
      subject.new.must have_valid(:quantity).when(1)
    end
  end
end
