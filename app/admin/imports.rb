require 'students_importer'
require 'teachers_importer'

ActiveAdmin.register_page "Imports" do

  content do
    render "index"
  end

  page_action :import_students, :method => :post do
    f = StudentsImporter.new(params[:school_id], params[:file])
    f.call
    flash[:notice] = 'Students Import Completed.'
    redirect_to '/admin/imports'
  end

  page_action :import_teachers, :method => :post do
    f = TeachersImporter.new(params[:school_id], params[:file])
    f.call
    flash[:notice] = 'Teachers Import Completed.'
    redirect_to '/admin/imports'
  end

  page_action :handle_interest, :method => :get do
    StudentInterestWorker.perform_async(current_person.email)
    flash[:notice] = 'Worker Started'
    redirect_to '/admin/imports'
  end

end
