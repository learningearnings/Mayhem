module Teachers
  class OtuCodeTypesController < ApplicationController

    def index
      @categories = current_person.otu_code_categories.joins(:otu_code_type).order("otu_code_types.name, otu_code_categories.name").all
      @new_category = OtuCodeCategory.new
      @types = OtuCodeType.all
    end

    def new
    end

  end
end
