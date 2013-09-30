Spree::TaxonsController.class_eval do

  def show
    @taxon = Spree::Taxon.find_by_permalink!(params[:id])
    return unless @taxon

    with_filters_params = params
    with_filters_params[:searcher_current_person] = current_person
    with_filters_params[:current_school] = current_school
    with_filters_params[:filters] = session[:filters] || [1]
    with_filters_params[:taxon] = @taxon.id
    searcher = Spree::Config.searcher_class.new(with_filters_params)
 
    #@searcher = Spree::Config.searcher_class.new(params.merge(:taxon => @taxon.id))

    # For some reason, there is no current_user method on @searcher... this makes the filters not return anything
    # Can't think of a good reason to set current user on @searcher, since you can access current_user session anywhere
    # leaving it here, but commented out in case we decide we need this later
    # @searcher.current_user = try_spree_current_user

    @products = searcher.retrieve_products

    respond_with(@taxon)
  end

end


