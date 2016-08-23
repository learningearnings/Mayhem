# lifted from https://github.com/romul/spree-solr-search/blob/master/lib/spree/search/solr.rb
#    -dhw

module Spree::Search
#  class Filter < defined?(Spree::Search::MultiDomain) ? Spree::Search::MultiDomain :  Spree::Core::Search::Base
  class Filter < Spree::Search::MultiDomain
    attr_reader :current_school

    def retrieve_products
      @products_scope = get_base_scope
      @products_scope.includes([:master])
    end

    def manage_pagination
      false
    end

    protected
    def get_base_scope
      # Copied from spree-multi-domain/lib/spree/search/multi_domain.rb
      base_scope = @cached_product_group ? @cached_product_group.products.active : Spree::Product.active

      # Leadmins get to see out of stock products
      # don't use filters with LeAdmins

      unless (@current_user && @current_user.person.is_a?(LeAdmin))
        base_scope = base_scope.by_store(current_store) if current_store
        base_scope = base_scope.in_taxon(taxon) unless taxon.blank?
        base_scope = base_scope.not_excluded(current_school) if current_school
        base_scope = get_products_conditions_for(base_scope, keywords) unless keywords.blank?
        base_scope = base_scope.on_hand unless Spree::Config[:show_zero_stock_products]
        base_scope = base_scope.not_shipped_for_school_inventory
        base_scope = base_scope.above_min_grade(@current_person.grade).below_max_grade(@current_person.grade) if @current_person && !@current_user.person.is_a?(Teacher)
        if current_school.name == 'STI'
          base_scope = base_scope.not_charity
        end
      else
        base_scope = base_scope.by_store(Spree::Store.find_by_code('le'))
      end
      base_scope = add_search_scopes(base_scope)
      base_scope
    end

    def current_store
      current_school.store
    end

    def prepare(params)
      @properties[:filters] = nil
      @current_user = params[:searcher_current_user]
      @current_person = params[:searcher_current_person]
      @current_school = params[:current_school]
      @classrooms = params[:classrooms]
      super
    end
  end
end
