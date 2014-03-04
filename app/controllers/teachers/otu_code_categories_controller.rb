module Teachers
  class OtuCodeCategoriesController < ApplicationController

    def index
    end

    def create
      @category = OtuCodeCategory.new(params[:otu_code_category])
      if @category.save
        flash[:notice] = 'yay'
        redirect_to teachers_otu_code_types_path
      else
        flash[:error] = 'nope'
        render :index
      end
    end


    def otu_code_category
      binding.pry
    end
  end
end
