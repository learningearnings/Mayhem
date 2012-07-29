require 'test_helper'

describe School do
  subject { School }

  it "has the basics down" do
    subject.must_be_kind_of Class
  end

  describe "Validations" do
    it "initializises correctly" do
      subject.new.wont_be :valid?
      subject.new(:name => "MiniTest School").must_be :valid?
    end

  end
end


