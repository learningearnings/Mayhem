# lifted from https://github.com/romul/spree-solr-search/blob/master/lib/spree/search/solr.rb
#    -dhw

module Spree::Search
#  class Filter < defined?(Spree::Search::MultiDomain) ? Spree::Search::MultiDomain :  Spree::Core::Search::Base
  class Filter < Spree::Search::MultiDomain
    def retrieve_products
      @products_scope = get_base_scope
      curr_page = page || 1
      @products = @products_scope.includes([:master]).page(curr_page).per(per_page)
    end

    protected
    def get_base_scope
      base_scope = super
      base_scope.with_filter(@properties[:filters])
    end

    def prepare(params)
      @properties[:filters] = params[:filters] || [1]
      super
    end

  end
end
