class Poll < ActiveRecord::Base
  
  attr_accessible :title, :question, :active, :min_grade, :max_grade, as: :admin
  attr_accessible :title, :question, :active, :min_grade, :max_grade

  has_many :poll_choices

  scope :active, where('active = ?', true)
  scope :no_min_grade, where("min_grade IS NULL")
  scope :no_max_grade, where("max_grade IS NULL")
  scope :within_grade, lambda {|grade|  where("? BETWEEN min_grade AND max_grade", grade) }

  def grade_range
    self.min_grade..self.max_grade
  end

end
