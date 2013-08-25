require_relative 'active_model_command'
require_relative '../validators/array_of_integers_validator'

class FoodFightMessageStudentCommand < ActiveModelCommand
  attr_accessor :to_id, :from_id, :body, :subject

  validates :from_id, numericality: true, presence: true
  validates :body, presence: true

  def initialize params={}
    @to_id       = params[:to_id]
    @from_id     = params[:from_id]
    @body        = params[:body]
    @subject     = params[:subject]
  end

  def message_class
    Message
  end

  def execute!
    messages = []
    message = message_class.new to_id: @to_id, from_id: @from_id, subject: @subject, body: @body, category: "Food Fight!"
    if !message.valid?
      return false
    else
      message.save
      return true
    end
  end
end
