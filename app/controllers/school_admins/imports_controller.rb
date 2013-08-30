require 'students_importer'
require 'teachers_importer'
module SchoolAdmins
  class ImportsController < SchoolAdmins::BaseController

    def new_student_import
    end

    def import_students
      f = StudentsImporter.new(current_school.id, params[:file])
      f.call
      flash[:notice] = 'Import Completed.'
      redirect_to '/school_admins/dashboard'
    end

    def new_teacher_import
    end

    def import_teachers
      f = TeachersImporter.new(current_school.id, params[:file])
      f.call
      flash[:notice] = 'Import Completed.'
      redirect_to '/school_admins/dashboard'
    end
  end
end
