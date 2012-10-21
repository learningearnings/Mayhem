# lifted from https://github.com/romul/spree-solr-search/blob/master/lib/spree/search/solr.rb
#    -dhw

module Spree::Search
#  class Filter < defined?(Spree::Search::MultiDomain) ? Spree::Search::MultiDomain :  Spree::Core::Search::Base
  class Filter < Spree::Search::MultiDomain
    def retrieve_products
      @products_scope = get_base_scope
#      curr_page = @properties[:page] || 1
#      le_per_page = @properties[:per_page] || per_page
#      @products = @products_scope.includes([:master]).page(curr_page).per(le_per_page)
      @products_scope.includes([:master])

    end

    def manage_pagination
      false
    end

    protected
    def get_base_scope
      # Copied from spree-multi-domain/lib/spree/search/multi_domain.rb

      base_scope = @cached_product_group ? @cached_product_group.products.active : Spree::Product.active
      base_scope = base_scope.by_store(current_store_id) if current_store_id
      base_scope = base_scope.in_taxon(taxon) unless taxon.blank?

      base_scope = get_products_conditions_for(base_scope, keywords) unless keywords.blank?
      # Leadmins get to see out of stock products
      unless  (@current_user && @current_user.person.is_a?(LeAdmin))
        base_scope = base_scope.on_hand unless Spree::Config[:show_zero_stock_products]
      end
      base_scope = add_search_scopes(base_scope)
      unless  (@current_user && @current_user.person.is_a?(LeAdmin))
        base_scope.with_filter(@filters)
      end
      base_scope
    end

    def prepare(params)
      @filters = params[:filters] || [1]
      params[:filters] = nil
      @properties[:filters] = nil
      @current_user = params[:searcher_current_user]
      super
    end
  end
end
