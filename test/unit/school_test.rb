require 'test_helper'

describe School do
  subject { School }

  it "has the basics down" do
    subject.must_be_kind_of Class
  end

  describe "Validations" do
    it "initializes correctly" do
      subject.new.wont_be :valid?
      subject.new(:name => "MiniTest School").must_be :valid?
    end
  end

  it "has an account name" do
    subject.new(name: 'foo').account_name.must_equal 'SCHOOLfoo'
  end

  it "responds to #balance with the balance of its plutus account" do
    school = subject.new(name: 'foo')
    account = mock('account')
    school.expects(:account).returns(account)
    account.expects(:balance).returns(0)
    school.balance.must_equal 0
  end

  it "responds to #account with the plutus account with its account name" do
    school = subject.new(name: 'foo')
    account = mock('account')
    Plutus::Asset.expects(:find_by_name).with("SCHOOLfoo").returns(account)
    school.account.must_equal account
  end

  it "can add an address to a school" do
    bama = State.find_by_abbr('AL')
    a = Address.new(:line1 => '4630 Wooddale Lane',
                    :city => 'Pelham',
                    :state => bama,
                    :zip => '35124')
    s = Factory.create(:school)
    s.addresses << a
    s.addresses.wont_be_empty
    puts "Bama :" + bama.to_yaml.to_s
    puts "Addresses:" + s.addresses.to_yaml.to_s
    s.addresses[0].state.abbr.must_be_equal('AL')
  end

end
