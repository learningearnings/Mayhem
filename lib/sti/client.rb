require 'httparty'
module STI
  class Client
    attr_accessor :session_token

    def initialize options={}
    end

    def get_session_token
      response = HTTParty.get("#{base_url}api/token", :basic_auth => authentication_hash)
      @session_token = response["access_token"]
    end

    def session_token
      @session_token ||= get_session_token
    end

    def session_information
      response = HTTParty.get("#{base_url}api/users/me", :headers => authorized_headers)
    end

    def rosters
      response = HTTParty.get("#{base_url}api/le/rosters", :headers => authorized_headers)
    end

    def schools
      response = HTTParty.get("#{base_url}api/le/schools", :headers => authorized_headers)
    end

    def sections
      response = HTTParty.get("#{base_url}api/le/sections", :headers => authorized_headers)
    end

    def staff
      response = HTTParty.get("#{base_url}api/le/staff", :headers => authorized_headers)
    end

    def students
      response = HTTParty.get("#{base_url}api/le/students", :headers => authorized_headers)
    end

    private
    def authorized_headers
      {"Authorization" => "Session #{session_token}"}
    end

    def authentication_hash
      {:username => ENV["STI_USERNAME"], :password => ENV["STI_PASSWORD"]}
    end

    def base_url
      "http://sandbox.sti-k12.com/learningearnings/"
    end
  end
end
