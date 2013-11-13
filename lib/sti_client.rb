require 'httparty'
class STIClient
  attr_accessor :session_token

  def initialize options={}
  end

  def get_session_token
    response = HTTParty.get("http://sandbox.sti-k12.com/learningearnings/api/token", :basic_auth => authentication_hash)
    @session_token = response["access_token"]
  end

  def session_token
    @session_token ||= get_session_token
  end

  def session_information
    response = HTTParty.get("http://sandbox.sti-k12.com/learningearnings/api/users/me", :headers => {"Authorization" => "Session #{session_token}"})
  end

  def authentication_hash
    {:username => ENV["STI_USERNAME"], :password => ENV["STI_PASSWORD"]}
  end
end
