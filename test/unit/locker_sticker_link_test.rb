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
end
