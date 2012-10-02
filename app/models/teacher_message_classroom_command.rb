require_relative 'active_model_command'
require_relative '../validators/array_of_integers_validator'

class TeacherMessageClassroomCommand < ActiveModelCommand
  attr_accessor :from_id, :to_classroom_id, :body, :subject

  validates :from_id, numericality: true, presence: true
  validates :to_classroom_id, numericality: true, presence: true

  def initialize params={}
    @from_id         = params[:from_id]
    @to_classroom_id = params[:to_classroom_id]
    @subject         = params[:subject]
    @body            = params[:body]
  end

  def message_class
    Message
  end

  def from
    Person.find(@from_id)
  end

  def execute!
    messages = []
    classroom = from.classrooms.find(@to_classroom_id)
    classroom.students.each do |student|
      message = message_class.new from_id: @from_id, to_id: student.id, subject: @subject, body: @body, category: "teacher"
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
