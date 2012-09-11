require 'test_helper_with_rails'

describe LockerStickerLink do
  subject{ LockerStickerLink.new }

  describe '[validations]' do
    it 'requires an x' do
      subject.wont have_valid(:x).when(nil)
      subject.wont have_valid(:x).when('asdf')
      subject.must have_valid(:x).when(1)
    end

    it 'requires a y' do
      subject.wont have_valid(:y).when(nil)
      subject.wont have_valid(:y).when('asdf')
      subject.must have_valid(:y).when(1)
    end

    it 'requires a locker_id' do
      subject.wont have_valid(:locker_id).when(nil)
      subject.wont have_valid(:locker_id).when('asdf')
      subject.must have_valid(:locker_id).when(1)
    end

    it 'requires a sticker_id' do
      subject.wont have_valid(:sticker_id).when(nil)
      subject.wont have_valid(:sticker_id).when('asdf')
      subject.must have_valid(:sticker_id).when(1)
    end
  end

  describe 'LockerStickerLink#sticker_image_url' do
    it "should be equal to the stickers image url" do
      locker_sticker_link = FactoryGirl.create(:locker_sticker_link)
      assert_equal locker_sticker_link.sticker_image_url, locker_sticker_link.sticker.image.url
    end
  end
end
