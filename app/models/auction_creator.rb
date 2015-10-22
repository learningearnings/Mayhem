class AuctionCreator
  attr_accessor :auction

  def initialize(params = nil, current_person)
    @params = params
    Rails.logger.debug("AKT : params #{@params.inspect}")
    @current_person = current_person
  end

  def execute!
    @auction = Auction.new(@params)
    auction.creator = @current_person
    auction.start_date = Time.zone.parse(@params[:start_date]) if @params[:start_date].present?
    auction.end_date = Time.zone.parse(@params[:end_date]) if @params[:end_date].present?
    auction.set_local if @current_person.is_a?(SchoolAdmin)
    if auction.save
      create_school_links 
      create_auction_zip_codes
      create_state_links
    end
  end

  def created?
    auction && auction.persisted?
  end

  private
  def create_school_links
    school_ids = @params[:school_ids]
    Rails.logger.debug("AKT: Create School Links: #{school_ids.inspect}")
    if school_ids
      school_ids.each do | school_id |
        school = School.where(id: school_id).first
        AuctionSchoolLink.create(:school_id => school.id, :auction_id => auction.id) if school
      end
    else
      if @current_person and @current_person.school
        AuctionSchoolLink.create(:school_id => @current_person.school.id, :auction_id => auction.id)         
      end
    end
  end
  def create_auction_zip_codes
    if @params[:auction_zip_code_ids]
      @params[:auction_zip_code_ids].each do |zip|
        zip = zip.strip
        AuctionZipCode.create(:zip_code => zip, :auction_id => auction.id) if zip.present?
      end
    end
  end  
  def create_state_links
    if @params[:state_ids]
      @params[:state_ids].each do |state|
        AuctionStateLink.create(:state_id => state, :auction_id => auction.id) if state.present?
      end    
    end
  end
end