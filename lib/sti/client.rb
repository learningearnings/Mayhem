require 'httparty'
module STI
  class Client
    attr_accessor :session_token, :base_url, :username, :password

    def initialize options={}
      @base_url = options.fetch(:base_url, "http://sandbox.sti-k12.com/learningearnings/api/")
      @username = options.fetch(:username, ENV["STI_USERNAME"])
      @password = options.fetch(:password, ENV["STI_PASSWORD"])
    end

    def get_session_token
      response = HTTParty.get("#{base_url}token", :basic_auth => authentication_hash)
      @session_token = response["access_token"]
    end

    def session_token
      @session_token ||= get_session_token
    end

    def session_information
      response = HTTParty.get("#{base_url}users/me", :headers => authorized_headers)
    end

    def rosters
      response = HTTParty.get("#{base_url}le/rosters", :headers => authorized_headers)
    end

    def schools
      response = HTTParty.get("#{base_url}le/schools", :headers => authorized_headers)
    end

    def sections
      response = HTTParty.get("#{base_url}le/sections", :headers => authorized_headers)
    end

    def staff
      response = HTTParty.get("#{base_url}le/staff", :headers => authorized_headers)
    end

    def students
      response = HTTParty.get("#{base_url}le/students", :headers => authorized_headers)
    end

    def link_status link_key
      if link_key
        url = "#{base_url}le/linkstatus?linkkey=#{link_key}"
      else
        url = "#{base_url}le/linkstatus"
      end
      HTTParty.get(url, :headers => authorized_headers)
    end

    private
    def authorized_headers
      {"Authorization" => "Session #{session_token}", "ApplicationKey" => "learningearnings WzvBW2c2suJex6V+Z22NpHZK7+mqCrUpvtw67lE7Js/8fo8E0QYngnQXBwjbs0yTkJ8hnATM/3LOKgZwB4cLsVccfXFOoTgImovQ/S9CP2s+V+AI/zmds3CZF9GD5+y6saxEKjduN/L+YYcKIYIs1UtQZfm/6lcFXPc1etZKGMk="}
    end

    def authentication_hash
      {:username => username, :password => password}
    end
  end
end
