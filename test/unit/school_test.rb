require 'test_helper_with_rails'

describe School do
  subject { School }

  it "has the basics down" do
    subject.must_be_kind_of Class
  end

  describe "Validations" do
    it "initializes correctly" do
      subject.new.wont_be :valid?
      subject.new(:name => "MiniTest School", :address => FactoryGirl.create(:address)).must_be :valid?
    end
  end

  it "has an account name" do
    subject.new(name: 'foo').name.must_equal "foo"
  end

  it "responds to #balance with the balance of its plutus account" do
    school = subject.new(name: 'foo')
    account = mock('account')
    school.expects(:main_account).returns(account)
    account.expects(:balance).returns(0)
    school.balance.must_equal 0
  end

  it "responds to #account with the plutus account with its account name" do
    school = subject.new(name: 'foo')
    account = mock('account')
    Plutus::Asset.expects(:find_by_name).with("SCHOOL#{school.id} MAIN").returns(account)
    school.main_account.must_equal account
  end

  it "can add an address to a school" do
    bama = FactoryGirl.create(:state)
    a = Address.new(:line1 => '4630 Wooddale Lane',
                    :city => 'Pelham',
                    :state => bama,
                    :zip => '35124')
    school = FactoryGirl.create(:school)
    school.addresses << a
    school.addresses.wont_be_empty
    school.addresses.must_include a
  end

  describe "School#store_subdomain" do
    it "should be state+id if there is a state" do
      school = FactoryGirl.create(:school)
      school.addresses << FactoryGirl.create(:address)
      assert_equal school.store_subdomain, "#{school.addresses.first.state.abbr}#{school.id}".downcase
    end
  end

  describe "#teachers_available_for_delivery" do
    subject{ FactoryGirl.create(:school) }
    let(:school_admin){ FactoryGirl.create(:school_admin, status: 'active') }
    before do
      FactoryGirl.create(:school_admin_school_link, person: school_admin, school: subject)
    end

    it "lists school admins that can deliver rewards" do
      school_admin.update_attribute(:can_deliver_rewards, true)
      subject.teachers_available_for_delivery.include?(school_admin).must_equal true
    end

    it "doesn't list school admins that can't deliver rewards" do
      subject.teachers_available_for_delivery.include?(school_admin).must_equal false
    end
  end
end
