class AuctionCreator
  attr_accessor :auction

  def initialize(params = nil, current_person)
    @params = params
    @current_person = current_person
  end

  def execute!
    @auction = Auction.new(@params)
    auction.creator = @current_person
    auction.start_date = Time.zone.parse(@params[:start_date])
    auction.end_date = Time.zone.parse(@params[:end_date])
    auction.set_local if current_person.is_a?(SchoolAdmin)
    create_school_links if auction.save
  end

  def created?
    auction && auction.persisted?
  end

  private
  def create_school_links
    # TODO: Replace this with parameter being passed in
    AuctionSchoolLink.create(:school_id => current_person.school.id, :auction_id => auction.id)
  end
end
