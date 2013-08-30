require 'students_importer'
require 'students_importer2'
require 'teachers_importer'
module SchoolAdmins
  class ImportsController < SchoolAdmins::BaseController

    def new_student_import
    end

    def import_students
      f = StudentsImporter2.new(current_school.id, params[:file])
      f.call
      flash[:notice] = 'Import Completed.'
      redirect_to '/school_admins/dashboard'
    end

    def new_teacher_import
    end

    def import_teachers
      f = TeachersImporter.new(current_school.id, params[:file].path)
      f.call
      flash[:notice] = 'Import Completed.'
      redirect_to '/school_admins/dashboard'
    end
  end
end
