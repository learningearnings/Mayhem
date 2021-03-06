require 'test_helper_with_rails'

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

    it 'must have a valid category' do
      subject.wont have_valid(:category).when(nil)
      subject.wont have_valid(:category).when('giggity')
      subject.must have_valid(:category).when('friend')
      subject.must have_valid(:category).when('school')
      subject.must have_valid(:category).when('teacher')
      subject.must have_valid(:category).when('system')
    end
  end

  it "can be replied to unless it's a system message" do
    subject.category = 'friend'
    subject.replyable?.must_equal(true)
  end

  it "cannot be replied to if it's a system message" do
    subject.category = 'system'
    subject.replyable?.must_equal(false)
  end

  it "cannot be replied to if it has associated bucks" do
    subject.category = 'friend'
    def subject.otu_codes; [1,2]; end
    subject.replyable?.must_equal(false)
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
