module Teachers
  class OtuCodeCategoriesController < ApplicationController

    def index
    end

    def create
      if params[:otu_code_category_id].present?
        @category = OtuCodeCategory.find(params[:otu_code_category_id])
        if @category.update_attributes(params[:otu_code_category])
          flash[:notice] = 'Buck Category Updated'
          redirect_to teachers_otu_code_types_path
        else
          flash[:error] = 'nope'
          render :index
        end
      else
        @category = OtuCodeCategory.new(params[:otu_code_category])
        if @category.save
          flash[:notice] = 'Buck Category Created'
          redirect_to teachers_otu_code_types_path
        else
          flash[:error] = 'nope'
          render :index
        end
      end
    end

    def get_category
      category = OtuCodeCategory.find params[:category_id]
      respond_to do |format|
        format.js do
          render :json => {:type => {:name => category.otu_code_type.name, :id => category.otu_code_type.id}, :category => {:name => category.name, :id => category.id}}, :layout => false
        end
      end

    end
  end
end
