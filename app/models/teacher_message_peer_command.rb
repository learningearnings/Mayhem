require_relative 'active_model_command'
require_relative '../validators/array_of_integers_validator'

class TeacherMessagePeerCommand < ActiveModelCommand
  attr_accessor :from_id, :to_ids, :subject, :body

  validates :from_id, numericality: true, presence: true
  validates :to_ids, presence: true, array_of_integers: true

  def initialize params={}
    @from_id = params[:from_id]
    @to_ids  = params[:to_ids]
    @body    = params[:body]
    @subject = params[:subject]
  end

  def message_class
    Message
  end

  def execute!
    messages = []
    @to_ids.each do |to_id|
      message = message_class.new from_id: @from_id, to_id: to_id, subject: @subject, body: @body, category: "teacher"
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
