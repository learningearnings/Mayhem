module Reports
  class StudentActivity < Activity
    def person_base_scope
      school.students.includes(:user)
    end
  end
end
