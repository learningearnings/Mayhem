module Teachers
  class OtuCodeCategoriesController < ApplicationController

    def index
    end

    def create
      if params[:otu_code_category_id].present?
        @category = current_school.otu_code_categories.unscoped.find(params[:otu_code_category_id])
        if @category.update_attributes(params[:otu_code_category])
          flash[:notice] = 'Category Updated'
          redirect_to teachers_otu_code_types_path
        else
          flash[:error] = "Couldn't update category"
          render :index
        end
      else
        @category = current_school.otu_code_categories.new(params[:otu_code_category])
        if @category.save
          flash[:notice] = 'Category Created'
          #MixPanelTrackerWorker.perform_async(current_user.id, 'Add Credit Category', mixpanel_options)
          redirect_to teachers_otu_code_types_path
        else
          flash[:error] = "Couldn't create category"
          render :index
        end
      end
    end

    def destroy
      current_school.otu_code_categories.find(params[:id]).destroy
      #Why do we have two controllers for this? :(
      redirect_to teachers_otu_code_types_path, notice: "Category Deleted"
    end

    def get_category
      category = current_school.otu_code_categories.find(params[:category_id])
      respond_to do |format|
        format.js do
          render :json => {:type => {:name => category.otu_code_type.name, :id => category.otu_code_type.id}, :category => {:name => category.name, :id => category.id, :person_id => category.person_id}}, :layout => false
        end
      end
    end
  end
end
