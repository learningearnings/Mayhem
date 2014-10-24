require 'httparty'
module STI
  class Client
    attr_accessor :session_token, :base_url, :username, :password

    include HTTParty

    format :json

    def initialize options={}
      @base_url = options.fetch(:base_url, "http://sandbox.sti-k12.com/learningearnings/api/")
      @username = options.fetch(:username, ENV["STI_USERNAME"])
      @password = options.fetch(:password, ENV["STI_PASSWORD"])
    end

    def get_session_token
      response = self.class.get("#{base_url}token", :basic_auth => authentication_hash)
      @session_token = response["access_token"]
    end

    def session_token
      @session_token ||= get_session_token
    end

    def perfect_attendance sti_school_id, start_date, end_date
      attendance_request("perfectattendance", sti_school_id, start_date, end_date)
    end

    def no_tardies sti_school_id, start_date, end_date
      attendance_request("notardies", sti_school_id, start_date, end_date)
    end

    def no_infractions sti_school_id, start_date, end_date
      attendance_request("noinfractions", sti_school_id, start_date, end_date)
    end

    def session_information
      self.class.get("#{base_url}users/me", :headers => authorized_headers)
    end

    def rosters
      self.class.get("#{base_url}le/rosters", :headers => authorized_headers)
    end

    def schools
      self.class.get("#{base_url}le/schools", :headers => authorized_headers)
    end

    def sections
      self.class.get("#{base_url}le/sections", :headers => authorized_headers)
    end

    def staff
      self.class.get("#{base_url}le/staff", :headers => authorized_headers)
    end

    def students
      self.class.get("#{base_url}le/students", :headers => authorized_headers)
    end

    # Async api
    def async_rosters(version=nil)
      url = "#{base_url}le/sync/rosters"
      url += "/#{version}" if version
      self.class.get(url, :headers => authorized_headers)
    end

    def async_sections(version=nil)
      url = "#{base_url}le/sync/sections"
      url += "/#{version}" if version
      self.class.get(url, :headers => authorized_headers)
    end

    def async_staff(version=nil)
      url = "#{base_url}le/sync/staff"
      url += "/#{version}" if version
      self.class.get(url, :headers => authorized_headers)
    end

    def async_students(version=nil)
      url = "#{base_url}le/sync/students"
      url += "/#{version}" if version
      self.class.get(url, :headers => authorized_headers)
    end

    def set_school_synced school_id, status = true
      options = { :body => {"Address" => "null", "City" => "null", "Id" => school_id, "IsEnabled" => true, "IsSyncComplete" => status, "Name" => "null", "PostalCode" => "null", "State" => "null"}, :headers => authorized_headers }
      self.class.put("#{base_url}le/schools/#{school_id}", options)
    end

    def link_status link_key
      if link_key
        url = "#{base_url}le/linkstatus?linkkey=#{link_key}"
      else
        url = "#{base_url}le/linkstatus"
      end
      self.class.get(url, :headers => authorized_headers)
    end

    private
    def authorized_headers
      {"Authorization" => "Session #{session_token}", "ApplicationKey" => "learningearnings WzvBW2c2suJex6V+Z22NpHZK7+mqCrUpvtw67lE7Js/8fo8E0QYngnQXBwjbs0yTkJ8hnATM/3LOKgZwB4cLsVccfXFOoTgImovQ/S9CP2s+V+AI/zmds3CZF9GD5+y6saxEKjduN/L+YYcKIYIs1UtQZfm/6lcFXPc1etZKGMk="}
    end

    def authentication_hash
      {:username => username, :password => password}
    end

    def attendance_request method, sti_school_id, start_date, end_date
      self.class.get("#{base_url}le/#{method}/#{sti_school_id}?startdate=#{start_date}&enddate=#{end_date}", :headers => authorized_headers).parsed_response
    end
  end
end
