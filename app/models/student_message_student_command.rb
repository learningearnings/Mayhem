class StudentMessageStudentCommand < ActiveModelCommand
  attr_accessor :from_id, :to_ids, :canned_message

  validates :from_id, numericality: true, presence: true
  validates :to_ids, presence: true, array_of_integers: true
  validates :canned_message, presence: true, inclusion: { in: Message.canned_messages, message: "must be one of the canned messages" }

  def initialize params={}
    @from_id        = params[:from_id]
    @to_ids         = params[:to_ids]
    @canned_message = params[:canned_message]
  end

  def message_class
    Message
  end

  def execute!
    messages = []
    @to_ids.each do |to_id|
      message = message_class.new from_id: @from_id, to_id: to_id, subject: @canned_message, body: @canned_message
      messages << message
    end
    any_invalid = messages.detect{|m| !m.valid? }
    if any_invalid
      return false
    else
      messages.map(&:save)
      return true
    end
  end
end
