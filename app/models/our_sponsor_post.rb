class OurSponsorPost < Post
  def body
    read_attribute(:body).present? ? read_attribute(:body) : default_text
  end

  def default_text
    OurSponsorPost.published.most_recent.where(school_id: nil).first.try(:body) || "No sponsor yet"
  end
end
