require 'powerschool-client/rest_connector/connector.rb'
require 'powerschool-client/api/powerschool_object.rb'
Dir[File.dirname(__FILE__) + '/powerschool-client/api//*.rb'].each {|file| require file }

# require 'ruby-debug'
module Powerschool
  class Client
    attr_reader :connector

    class PowerschoolClientError < StandardError
      attr_reader :data
      def initialize(data)
        @data = data
        super()
      end
    end

    class RequiredFieldError < PowerschoolClientError; end
    class InvalidPowerSchoolScore < PowerschoolClientError; end
    class InvalidPowerschoolAssignment < PowerschoolClientError; end
    class PowerschoolServerError < PowerschoolClientError; end

    USER_TYPE = {
     :faculty => 1,
     :student => 2
    }

    def initialize(options)
      @connector = RestConnector::Connector.new(options["url"], options["id"], options["secret"], options["retries"])
      @connector.start_logging_responses_to options["log_responses"] unless options["log_responses"].nil?
      puts "Connector: #{@connector}"
    end

    def required_fields?(req=[], fields)
      req.each do |v|
        raise RequiredFieldError.new(error: 'Missing required field: ' + v.to_s) unless fields.include? v
      end
    end

    def update_multiple_scores(score_array, assignment_id)
      to_post = score_array.collect { |sc|
        {
          :student => {
            :id => sc[:student_id]
          },
          :score_entered => sc[:score]
        }
      }

      data = {
        :assignment_scores => {
          :assignment_score => to_post
        },
        :base_path => '/powerschool-ptg-api/v2',
        :assignment_id => assignment_id
      }

      res = @connector.put(:multiple_scores, data)
      parsed = JSON.parse(res) rescue {}

      unless parsed['assignment_scores'].empty? || parsed['assignment_scores']['assignment_score'].empty?
        error_scores = parsed['assignment_scores']["assignment_score"].select{|sc| sc["batch_result"]["code"] == 409 }
        if !error_scores.empty? # response could be 200OK but have error scores
          raise InvalidPowerSchoolScore.new(response: error_scores), "Invalid scores on mass update assignment_id '#{assignment_id}'"
        end
      end

      if res.code != 200
        raise InvalidPowerSchoolScore.new(response: res), "Invalid scores on mass update assignment_id '#{assignment_id}'"
      end

      res.code
    end

    def update_student_score(student_id, score, assignment_id)
      if !score
        raise InvalidPowerSchoolScore.new(error: "Invalid score '#{score}' for student_id '#{student_id}' and assignment_id '#{assignment_id}'"), "invalid score"
      end

      data = {
          :assignment_id => assignment_id,
          :student_id => student_id,
          :base_path => '/powerschool-ptg-api/v2',
          :assignment_score => { :score_entered => score }
      }
      begin
        res = @connector.put(:single_score, data)
      rescue => e
        raise InvalidPowerSchoolScore.new( response: e), "Invalid update data for student_id '#{student_id} and assignment_id '#{assignment_id}'"
      end
      parsed = JSON.parse(res) rescue {}

      if ![201,204].include? res.code
        raise InvalidPowerSchoolScore.new( response: parsed['error_message']), "Invalid score on update for student_id '#{student_id} and assignment_id '#{assignment_id}'"
      end

      res.code
    end

    def update_assignment(assignment_data)
      to_update = {
          :assignment_id => assignment_data.delete(:id),
          :base_path => '/powerschool-ptg-api/v2',
          :assignment => assignment_data
      }

      @connector.put(:assignment, to_update)
    end

    # returns path of newly created PowerSchool object
    def create_assignment_for_section(section_id, assignment = {}, opts = {} )
      requirements = [:name, :abbreviation, :description, :date_assignment_due, :haiku_assignment_id]
      #required_fields?(requirements, opts)

      data = {
          :section_id => section_id,
          :assignment => assignment,
          :base_path => '/powerschool-ptg-api/v2'
      }

      @connector.post(:create_assignment, data) {  |response, request, result, &block|
        if [400,404,409].include? response.code
          raise InvalidPowerschoolAssignment.new( response: response, request: request), "Invalid data on assignment creation: cde #{response.inspect}"
        else
          res = response.headers[:location]

          if opts[:return_id]
            res = res[res.rindex('/')+1..-1]
          end

          res
        end
      }
    end

    def delete_assignment(id)
      opts = {
        :assignment_id => id,
        :base_path => '/powerschool-ptg-api/v2'
      }

      results = @connector.delete(:assignment, opts)
    end

    def delete_student_score(assignment_id, student_id)
      opts = {
        :assignment_id => assignment_id,
        :student_id => student_id,
        :base_path => '/powerschool-ptg-api/v2'
      }

      results = @connector.delete(:single_score, opts)
    end

    def get_courses(school_id)
      results = @connector.get(:courses, school_id: school_id, paginated:true)
      create_powerschool_objects(Powerschool::Course, results["courses"]["course"])
    end
    
    def get_district
      results = @connector.get(:district, paginated: false)
      #create_powerschool_objects(Powerschool::District, results["district"]["district"])
    end
    
    def get_weekly_credits_no_absences
      results = records = power_query("com.powerschool.le.students.attendance.weekly")
    end

    def get_weekly_credits_no_tardies
      results = records = power_query("com.powerschool.le.students.tardies.weekly")
    end
    
    def get_weekly_credits_no_infractions
      results = records = power_query("com.powerschool.le.students.infraction.weekly")
    end
    
        
    def get_schools
      results = @connector.get(:schools, :expansions => 'school_boundary', paginated: true)
      puts "Client get schools connector: #{@connector.inspect}"
      puts "Client get schools results: #{results.inspect}"      
      create_powerschool_objects(Powerschool::School, results["schools"]["school"])
    end

    def get_sections(school_id, start_year = nil)
      
      q = start_year ? {query: "term.start_year==#{start_year}"} : nil
      results = @connector.get(:sections, school_id: school_id, paginated:true, queries: q)
      create_powerschool_objects(Powerschool::Section, results["sections"]["section"])
    rescue
      puts "Error section results: #{results.inspect}"
    end

    def get_students(school_id, expansions='contact_info')
      results = @connector.get(:students, school_id: school_id, expansions: expansions, paginated: true)
      create_powerschool_objects(Powerschool::Student, results["students"]["student"])
    end

    def get_students_with_contacts(school_id)
      results = @connector.get(:students, school_id: school_id, :expansions => "contact,contact_info", paginated: true)
      create_powerschool_objects(Powerschool::Student, results["students"]["student"])
    end

    def get_contact_info_for_student(student_id)
      resp = @connector.get(:student, :student_id => student_id, :expansions => 'contact,contact_info')
      create_powerschool_objects(Powerschool::Student, resp["student"])
    end

    def get_guardian_info_for_student(student_id)
      get_guardian_info(student_id)
    end

    def get_terms(school_id, start_year = nil)
      q = start_year ? {query: "start_year==#{start_year}"} : nil
      results = @connector.get(:terms, school_id:school_id, paginated:true, queries: q)
      create_powerschool_objects(Powerschool::Term,results["terms"]["term"])
    end


    def get_school(school_id)
      result = @connector.get(:school, school_id: school_id)
      result = result["school"].tap{|h| h.delete("@extensions");h.delete("@expansions")}
      Powerschool::School.new({values:result, client:self})
    end

    def get_section(section_id)
      result = @connector.get(:section, section_id: section_id)
      result = result["section"].tap{|h| h.delete("@extensions");h.delete("@expansions")}
      Powerschool::Section.new({values:result, client:self})
    end

    def get_staff_member(staff_id)
      result = @connector.get(:staff, staff_id: staff_id)
      result = result["staff"].tap{|h| h.delete("@extensions");h.delete("@expansions")}
      Powerschool::Staff.new({values:result, client:self})
    end

    def get_staff(school_id)
      results = @connector.get(:staffs, school_id: school_id, :expansions => "emails", paginated: true)
      create_powerschool_objects(Powerschool::Staff, results["staffs"]["staff"])
    end

    def get_term(term_id)
      result = @connector.get(:term, term_id: term_id)
      result = result["term"].tap{|h| h.delete("@extensions")}
      Powerschool::Term.new({values: result, client:self}) unless result.nil?
    end

    def get_enrollments(section_id)
      results = @connector.get(:section_enrollments, section_id: section_id, paginated: true)
      create_powerschool_objects(Powerschool::SectionEnrollment,results["section_enrollments"]["section_enrollment"])
    end

    def get_course(course_id)
      result = @connector.get(:course, course_id: course_id)
      result = result["course"].tap{|h| h.delete("@extensions")}
      Powerschool::Course.new({values: result, :client => self})
    end

    def get_student(student_id)
      result = @connector.get(:student, student_id: student_id)
      result = result["student"].tap{|h| h.delete("@extensions"); h.delete("@expansions")}
      Powerschool::Student.new({values: result, client: self})
    end

    def get_coteacher_sections(staff_ids)
      # This only returns the first 100 results. Keep that in mind.
      raise "Invalid" unless staff_ids
      staff_ids = [staff_ids] unless staff_ids.is_a? Array
      records = power_query("com.powerschool.core.users.coteacher_access_roles", {users_dcids: staff_ids})

      if records
        sections = {}
        records.each do |r|
          sections[r['tables']['users']['dcid']] ||= []
          sections[r['tables']['users']['dcid']] << r['tables']['sections']['dcid']
          sections[r['tables']['users']['dcid']].uniq!
        end
      end
      sections
    end

    def get_guardian_info(student_id = nil, data={})
      if student_id.nil?
        data[:paginated] = true
      else
        student_id = [student_id] unless student_id.is_a? Array
        data[:students_dcid] = student_id
      end
      create_powerschool_objects(Powerschool::Guardian, power_query("com.pearson.core.guardian.student_guardian_detail", data))
    end

    def get_section_gradebook_type(section_id, data={})
      data[:section_ids] = [section_id]
      result = power_query("com.powerschool.core.sections.gradebooktype", data).first
      result["gradebooktype"] == "PTP" ? :ptp : :ptg
    end

    def get_section_gradescale_dcid(section_id, data ={})
      data[:section_ids] = [section_id]
      result = power_query("com.powerschool.core.sections.gradescales", data).first
      result["gradescaleitemdcid"].to_i
    end

    def power_query(query_name, data={})
      data[:base_path] = '/ws'
      data[:query_name] = query_name
      response = @connector.post(:power_query, data)
      JSON.parse(response)['record']
    end

    def get_assignment(assignment_id)
      result = @connector.get(:assignment, assignment_id: assignment_id, :base_path => '/powerschool-ptg-api/v2')
      result = result["assignment"].tap{|h| h.delete("@extensions")}
      result[:id] = assignment_id.to_i
      Powerschool::Assignment.new({values:result, client:self}) unless result.nil?
    end

    def get_table(table_name, record_id, projection)
      @connector.get(:table, table_name: table_name, record_id: record_id, projection: projection,  base_path: '/ws')
    end

    def create_ptp_assignment_for_section(assignment, options={})
      data = assignment.to_hash.merge({base_path: '/ws/xte', query_params: options})
      @connector.post(:ptp_assignment_sections, data) {  |response, request, result, &block|
        if [200, 201, 202, 204].include? response.code
          response.headers[:location]
        elsif [400,404,409].include? response.code
          raise InvalidPowerschoolAssignment.new( response: response, request: request), "Invalid data on assignment creation: cde #{response.inspect}"
        elsif [500].include? response.code
          raise PowerschoolServerError.new( response: response, request: request), "The PowerSchool server responded with an error: #{response.inspect}"
        else
          raise response.inspect
        end
      }
    end

    def update_ptp_assigment_section(assignment, options={})
      data = assignment.to_hash.merge({base_path: '/ws/xte', query_params: options, assignmentid: assignment._id})
      @connector.put(:ptp_assignment_section, data) {  |response, request, result, &block|
        if ["200", "201", "202", "204"].include? result.code
          true
        elsif ["400","404","409", "412"].include? result.code
          raise InvalidPowerschoolAssignment.new( response: response, request: request), "Invalid data on assignment creation: cde #{response.inspect}"
        elsif ["500"].include? response.code
          raise PowerschoolServerError.new( response: response, request: request), "The PowerSchool server responded with an error: #{response.inspect}"
        else
          raise result.inspect
        end
      }
    end

    def delete_ptp_assignment(assignmentid, options={})
      opts = {
        assignmentid: assignment_id,
        query_params: options,
        base_path: 'powerschool-ptg-api/v2'
      }

      @connector.delete(:ptp_assignment_section, opts)
    end

    def delete_ptp_assignment_section_online_work(id)
      opts = {
        :assignment_section_id => id,
        :base_path => '/ws/xte'
      }

      results = @connector.delete(:ptp_assignment_section_online_work, opts)
    end

    def get_ptp_assignment_sections(options={})
      raise "missing params" unless options[:users_dcid] && options[:section_ids]
      results = @connector.get(:ptp_assignment_sections, base_path: '/ws/xte', query_params: options)
      results.map! do |assignment|
        Powerschool::PtpAssignment.new(assignment)
      end
    end

    def get_ptp_assignment_section(assignment_id, options={})
      raise "missing params" unless options[:users_dcid] && assignment_id
      results = @connector.get(:ptp_assignment_section, assignmentid: assignment_id, base_path: '/ws/xte', query_params: options)
      Powerschool::PtpAssignment.new(results)
    end

    def get_ptp_scores(assignment_id, section_id, options={})
      raise "missing params" unless options[:users_dcid] && assignment_id && section_id
      data = {
      	:assignment_ids => [assignment_id],
      	:section_ids => [section_id],
        :base_path => '/ws/xte',
        :query_params => options
      }
      results = JSON.parse(@connector.post(:ptp_assignment_scores, data)).map do |score|
        score.delete("$breach_mitigation")
        Powerschool::PtpAssignmentScore.new(score)
      end
    end

    def update_ptp_score(score, options={})
      raise "missing params" unless options[:users_dcid] && score
      data = {"assignment_scores" => [score.to_hash]}.merge({base_path: '/ws/xte', query_params: options})
      result = @connector.put(:ptp_score, data)
    end

    def get_teacher_categories(options={})
      raise "missing params" unless options[:users_dcid]
      options[:year_id] ||= "0"
      results = @connector.get(:ptp_teacher_categories, base_path: '/ws/xte', query_params: options)
      results.map! do |teacher_category|
        Powerschool::TeacherCategory.new(teacher_category)
      end
    end

    private

    def create_powerschool_objects(klass, results)
      results = [results] if results.class == Hash
      return [] if results.blank?
      ret = results.collect do |result|
        klass.new({values:result, client:self})
      end
      ret || []
    end

    def get_metadata
      @metadata = @connector.get(:metadata).fetch("metadata")
    end

  end
end
