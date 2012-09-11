require 'test_helper_with_rails'

describe Locker do
  subject { Locker.new }

  describe "[validations]" do
    it "requires a person_id" do
      subject.wont have_valid(:person_id).when(nil)
      subject.must have_valid(:person_id).when(1)
    end
  end

  describe "<<" do
    before do
      @sticker = FactoryGirl.create(:sticker)
      @link = subject << @sticker
    end

    it "should add a new locker stinker link" do
      assert @link.is_a?(LockerStickerLink)
    end

    it "should have the sticker related to the link" do
      assert_equal @link.sticker, @sticker
    end

    it "should relate the link to the subject" do
      assert subject.locker_sticker_links.include?(@link)
    end
  end
end
