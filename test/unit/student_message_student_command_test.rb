require 'test_helper'

describe StudentMessageStudentCommand do
  subject { StudentMessageStudentCommand.new }

  it "requires valid from_id" do
    subject.wont have_valid(:from_id).when(nil)
    subject.wont have_valid(:from_id).when('asdf')
    subject.must have_valid(:from_id).when(1)
  end

  it "requires valid to_ids" do
    subject.wont have_valid(:to_ids).when(nil)
    subject.wont have_valid(:to_ids).when(['asdf'])
    subject.must have_valid(:to_ids).when([1])
    subject.must have_valid(:to_ids).when([1, 2])
  end

  it "requires valid canned_message" do
    subject.wont have_valid(:canned_message).when(nil)
    subject.wont have_valid(:canned_message).when("When in the course of human events...")
    subject.must have_valid(:canned_message).when(Message.canned_messages.first)
  end

  it "sends all the messages when #execute! is called" do
    subject.from_id = 1
    subject.to_ids = [2, 3]
    subject.canned_message = Message.canned_messages.first

    mock_message_class = mock "Message"
    mock_message = mock "message"
    mock_message_class.expects(:new).returns(mock_message).times(2)
    mock_message.expects(:valid?).returns(true).times(2)
    mock_message.expects(:save).returns(true).times(2)
    subject.expects(:message_class).returns(mock_message_class).times(2)
    subject.execute!.must_equal true
  end
end
