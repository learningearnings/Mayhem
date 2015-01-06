class ClassroomStudentForm
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :classroom_id, :first_name, :last_name, :username, :grade, :password, :password_confirmation
  attr_reader :classroom

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :username, presence: true
  validates :grade, presence: true
  validates :password, presence: true, confirmation: true
  validate :unique_username, if: 'username.present?'

  def self.model_name
    ActiveModel::Name.new(self, nil, "User")
  end

  def persisted?
    false
  end

  def set_values(classroom_id, student_params)
    @classroom = Classroom.find(classroom_id)
    self.first_name = student_params[:first_name]
    self.last_name = student_params[:last_name]
    self.username = student_params[:username]
    self.grade = student_params[:grade]
    self.password = student_params[:password]
    self.password_confirmation = student_params[:password_confirmation]
  end

  def save
    if valid?
      student.save
      student << @classroom
      true
    else
      false
    end
  end

  def student
    @student ||= Student.new(student_params)
  end

  def student_params
    {
      first_name: first_name,
      last_name: last_name,
      grade: grade,
      username: username,
      password: password,
      password_confirmation: password_confirmation
    }
  end

  def unique_username
    if users = Spree::User.where(username: username)
      if users.any? && users.flat_map(&:school_ids).include?(@classroom.school.id)
        errors.add(:username, "has already been taken")
      end
    end
  end
end
