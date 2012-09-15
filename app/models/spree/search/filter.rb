# lifted from https://github.com/romul/spree-solr-search/blob/master/lib/spree/search/solr.rb
#    -dhw

module Spree::Search
#  class Filter < defined?(Spree::Search::MultiDomain) ? Spree::Search::MultiDomain :  Spree::Core::Search::Base
  class Filter < Spree::Search::MultiDomain
    def initialize(params)
      super
    end

    def retrieve_products
      @products_scope = get_base_scope
      curr_page = page || 1
      @products = @products_scope.includes([:master]).page(curr_page).per(per_page)
      super
    end

    protected
    def get_base_scope
      base_scope = super
      new_scope = base_scope.with_filter(@properties[:filters])
      new_scope
    end
    def get_products_conditions_for(base_scope, query)
      super
    end

    def prepare(params)
      @properties[:filters] = params[:filters] || [1]
      super
    end

  end
end
