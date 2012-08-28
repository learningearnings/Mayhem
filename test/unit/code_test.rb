require 'test_helper'

describe Code do
  subject { Code.new }

  it "won't generate ambiguous codes" do
    ids = [1, 3, 7, 21, 300]
    ids.each do |id|
      Code.generate_code(id).wont_include Code.ambiguous_letters
    end
  end
end
