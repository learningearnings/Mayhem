module Teachers
  class OtuCodeTypesController < ApplicationController

    def index
      @categories = current_person.otu_code_categories
      @new_category = OtuCodeCategory.new
      @types = OtuCodeType.all
    end

    def new
    end

  end
end
