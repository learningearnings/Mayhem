require 'test_helper'

describe UserAvatarLink do
  subject { UserAvatarLink }

  it "has the basics down" do
    subject.must_be_kind_of Class
  end

  describe "Validations" do
    it "wont have a valid user_id when nil" do
      subject.new.wont have_valid(:user_id).when(nil)
    end

    it "must have a valid user_id when 1" do
      subject.new.must have_valid(:user_id).when(1)
    end

  end
end


