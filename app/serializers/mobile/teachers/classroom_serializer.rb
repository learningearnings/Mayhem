class Mobile::Teachers::ClassroomSerializer < ActiveModel::Serializer
  attributes :id, :name, :students

  def students
    object.students.map do |student|
      Mobile::Teachers::StudentSerializer.new(student, scope: scope, root: false)
    end
  end
end
