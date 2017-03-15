# require 'hmac-sha1'
require 'cgi'
require 'base64'
require 'json'
require 'faraday'
require 'net/http/persistent'
require 'rest-client'
require 'date'
require 'fileutils'

module RestConnector
  class Connector
    class ConnectionResetException
      def self.===(exception)
        exception.is_a?(Errno::ECONNRESET) ||
        exception.is_a?(Faraday::Error::ConnectionFailed) ||
        (exception.is_a?(Net::HTTP::Persistent::Error) && exception.message && exception.message.match(/Errno::ECONNRESET/))
      end
    end

    attr_accessor :log_responses, :retries, :retry_sleep, :web_services_url, :conn, :token

    BASE_PATH = "/ws/v1"

    MAX_PAGE_SIZE = 10000
    PATHS = {
      :token                  => "/oauth/access_token",
      :district               => "/district",
      :schools                => "/district/school",
      :school                 => "/school/:school_id",
      :students               => "/school/:school_id/student",
      :student                => "/student/:student_id",
      :sections               => "/school/:school_id/section",
      :section                => "/section/:section_id",
      :courses                => "/school/:school_id/course",
      :course                 => "/course/:course_id",
      :terms                  => "/school/:school_id/term",
      :term                   => "/term/:term_id",
      :staffs                 => "/school/:school_id/staff",
      :staff                  => "/staff/:staff_id",
      :multiple_scores        => "/assignment/:assignment_id/score",
      :single_score           => "/assignment/:assignment_id/student/:student_id/score",
      :assignment             => "/assignment/:assignment_id",
      :create_assignment      => "/section/:section_id/assignment",
      :section_enrollments     => "/section/:section_id/section_enrollment",
      :table                  => "/schema/table/:table_name/:record_id",
      :metadata               => "/metadata",
      :power_query            => "/schema/query/:query_name",
      :ptp_assignment_sections => "/section/assignment", # GET POST
      :ptp_assignment_section  => "/section/assignment/:assignmentid", # GET PUT DELETE
      :ptp_teacher_categories  => "/teacher_category",
      :ptp_score               => "/score", # PUT
      :ptp_assignment_scores   => "/assignment_score", # POST
      :ptp_assignment_section_online_work => "/online_work/assignment_section/:assignment_section_id" # DELETE
    }

    def initialize(url, id, secret, retries=0,log_responses=false)
      headers = {
        content_type: 'application/x-www-form-urlencoded;charset=UTF-8',
        authorization: 'Basic ' + Base64.strict_encode64("#{id}:#{secret}")
      }

      body = {
        grant_type: "client_credentials"
      }

      self.retries = retries.to_i
      self.retry_sleep = self.retries
      self.web_services_url = url

      establish_connection_object

      response = conn.post do |req|
        req.url PATHS.fetch(:token)
        req.body = body
        req.headers = headers
      end
      res = JSON.parse(response.body)
      raise res["error"] if res["error"]
      @token = res
    end

    def establish_connection_object
      warn "STDOUT logging will break services that depend on quiet connections" if log_responses
      self.conn = Faraday.new(:url => web_services_url) do |faraday|
        faraday.request  :url_encoded             # form-encode POST params
        faraday.response :logger if log_responses                 # log requests to STDOUT
        faraday.adapter  :net_http_persistent
      end
    end

    def start_logging_responses_to(path)
      self.log_responses = path
    end

    def stop_logging_responses
      self.log_responses = false
    end

    def is_logging_responses?
      !!self.log_responses
    end

    def reset_retries
      self.retries = retry_sleep
    end

    def connect(url)
      res = conn.get do |req|
        req.url url
        req.headers = default_headers
      end
      reset_retries

      archive_response_from_endpoint(url,res.body) if is_logging_responses?

      JSON.parse(res.body)
    rescue ConnectionResetException => e
      archive_response_from_endpoint(url, JSON.dump({'error_message'=>e.message, 'code'=>(res ? res.status : '(no result)'), 'retry'=>retries})) if is_logging_responses?
      unless (self.retries -= 1) < 0
        sleep ((retry_sleep - retries)**2)
        establish_connection_object
        retry
      end
      raise e
    end

    def archive_response_from_endpoint(endpoint, resp)
      outfile = 'response' + endpoint.gsub(/\/|\?|\&/,'_')

      outfile.slice!(/pagesize=(.*)/)
      full_outfile_path = File.join(log_responses, outfile)
      50.times do |i|
        extra = (i > 0 ? ".v#{i}" : '')
        unless File.exists?(full_outfile_path + extra + '.json')
          outfile = full_outfile_path + extra
          break
        end
      end

      dir = File.dirname(outfile)

      FileUtils.mkdir_p(dir) unless File.directory?(dir)

      File.write(outfile + '.json', JSON.pretty_unparse(JSON.parse(resp)))
    end

    def put(key, opts, &block)
      endpoint = PATHS.fetch(key).dup
      url = @web_services_url + (opts.delete(:base_path) || BASE_PATH) + construct_path_from_keys(endpoint, opts)

      opts = sanitize_opts_of_endpoint_data(opts, PATHS.fetch(key).dup)

      query_options = construct_query_from_keys(opts)
      opts.delete(:query_params)
      results = RestClient.put(url + query_options, "#{opts.to_json}", default_headers, &block)

      archive_response_from_endpoint(endpoint,results) if is_logging_responses?

      results
    end

    def post(key, opts = {}, &block)
      return paginated_post(key, opts, &block) if opts.delete(:paginated)

      is_counting = opts.delete(:count)
      endpoint = PATHS.fetch(key).dup
      options = ""
      options << "/count" if is_counting

      query_options = construct_query_from_keys(opts)

      url = @web_services_url + (opts[:base_path] || BASE_PATH) + construct_path_from_keys(endpoint, opts)

      send_opts = sanitize_opts_of_endpoint_data(opts.dup, PATHS.fetch(key).dup)
      send_opts.delete(:queries)
      send_opts.delete(:base_path)
      send_opts.delete(:query_params)
      if query_options.blank?
        query_options = "?pagesize=0"
      else
        query_options = query_options + "&pagesize=0"
      end
      puts "Post: " + url + options + query_options
      results = RestClient.post(url + options + query_options, is_counting ? "" : "#{send_opts.to_json}", default_headers, &block)

      archive_response_from_endpoint(endpoint,results) if is_logging_responses?

      results
    end

    def delete(key, opts ={})
      endpoint = PATHS.fetch(key).dup
      query_options = construct_query_from_keys(opts)
      url = @web_services_url + (opts.delete(:base_path) || BASE_PATH) + construct_path_from_keys(endpoint, opts)
      res = RestClient.delete(url + query_options, default_headers)

      archive_response_from_endpoint(endpoint,res) if is_logging_responses?

      res.headers
    end

    def get(key, opts = {})
      return paginated_get(key, opts) if opts[:paginated]

      endpoint = PATHS.fetch(key).dup
      options = ""
      options << "/count" if opts.delete(:count)

      query_options = construct_query_from_keys(opts)

      endpoint = @web_services_url + (opts.delete(:base_path) || BASE_PATH) + construct_path_from_keys(endpoint,opts)

      connect(endpoint + options + query_options)
    end

    private

    def construct_query_from_keys(opts)
      query = ""
      query << "?" if opts[:queries] || opts[:expansions] || opts[:projection] || opts[:query_params]

      unless opts[:queries].nil?
        query << "page=#{opts[:queries][:page]}&" if opts[:queries][:page] && !opts[:count]
        query << "pagesize=#{opts[:queries][:pagesize]}&" if opts[:queries][:pagesize] && !opts[:count]
        query << "q=#{opts[:queries][:query]}" if opts[:queries][:query]
      end

      query = query.tap{|q| q << '&' if q.empty?} << "expansions=#{opts[:expansions]}" unless opts[:expansions].nil?
      query = query.tap{|q| q << '&' if q.empty?} << "projection=#{opts[:projection]}" unless opts[:projection].nil?

      unless opts[:query_params].nil?
        opts[:query_params].each do |qp, value|
          query << "#{'&' unless query == "?"}#{qp.to_s}=#{value.to_s}"
        end
      end

      query
    end

    def default_headers
      {
          "Accept" => 'application/json',
          "Content-Type"=> 'application/json',
          "Authorization" => "Bearer #{@token['access_token']}"
      }
    end

    # cleans the opts array of keys meant for path, if key ends with '/' or EOL
    def sanitize_opts_of_endpoint_data(opts, path)
      opts.delete_if {|k,v| path.match(/:#{k}(\/|$)/) }
    end

    def construct_path_from_keys(endpoint, keys)
      keys.each do |k, v|
        if v.nil?
          endpoint.gsub!(/(\?|\/)?:#{Regexp.quote(k)}/, v.to_s)
        else
          endpoint.gsub!(":#{k}", v.to_s)
        end
      end

      endpoint
    end

    def paginated_post(key, opts = {}, &block)
      raise "Unable to get paginated results for this key" unless multiple_results?(key)
      opts[:queries] ||= {}
      opts[:queries][:page] = (page = 1)
      opts[:queries][:pagesize] = MAX_PAGE_SIZE
      result, results, current_size = {}, [], 0
      target_size = JSON.parse(post(key, opts.merge({count:true})))["count"]

      while current_size < target_size
        result = post(key, opts, &block)

        results += result

        current_size = results.size
        opts[:queries][:page] = (page += 1)
      end
      results
    end

    def paginated_get(key, opts = {})
      raise "Unable to get paginated results for this key" unless multiple_results?(key)
      opts[:paginated] = false
      opts[:queries] ||= {}
      opts[:queries][:page] = (page = 1)
      opts[:queries][:pagesize] = MAX_PAGE_SIZE
      result, results, current_size = {}, [], 0


      target_size = get(key, opts.merge({count:true}))["resource"]["count"]
      while current_size < target_size
        result = get(key, opts)
        if result[key.to_s][key.to_s[0..-2]].is_a?(Hash)
          results = results + [result[key.to_s][key.to_s[0..-2]]]
        else
          results = results + result[key.to_s][key.to_s[0..-2]]
        end
        current_size = results.size
        opts[:queries][:page] = (page += 1)
      end

      if result[key.to_s].nil?
        {key.to_s=>{"@expansions"=>nil, "@extensions"=>nil, key.to_s[0..-2]=>results}}
      else
        {key.to_s=>{"@expansions"=>result[key.to_s]["@expansions"], "@extensions"=>result[key.to_s]["@extensions"], key.to_s[0..-2]=>results}}
      end
    end

    def multiple_results?(key)
      [:courses, :schools, :sections, :students, :terms, :staffs, :guardian_info, :section_enrollments].include?(key)
    end

  end
end
