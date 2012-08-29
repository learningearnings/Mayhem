require_relative '../test_helper'

describe Message do
  subject { FactoryGirl.build_stubbed(:message) }

  describe 'validations' do
    it 'must have a from_id' do
      subject.wont have_valid(:from_id).when(nil)
      subject.must have_valid(:from_id).when(1)
    end

    it 'must have a to_id' do
      subject.wont have_valid(:to_id).when(nil)
      subject.must have_valid(:to_id).when(1)
    end

    it 'must have a subject' do
      subject.wont have_valid(:subject).when(nil)
      subject.must have_valid(:subject).when('foo')
    end

    it 'must have a body' do
      subject.wont have_valid(:body).when(nil)
      subject.must have_valid(:body).when('foo')
    end
  end

  describe 'state machine' do
    before do
      # Here we make one that's not stubbed since state_machine transitions save
      # to the db
      @message = FactoryGirl.build(:message)
    end
    it 'starts off in an unread state' do
      @message.unread?.must_equal true
    end
    it 'transitions to read state with read!' do
      @message.read!
      @message.read?.must_equal true
    end
  end
end
