module Powerschool
  class PtpAssignment
    attr_accessor(:_id, :_name, :_assignmentsections, :standardcalcdirection, :standardscoringmethod)

    def initialize(values={})
      values = defaults.merge(values)
      values.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
      _assignmentsections.map! do |as_sec|
        Powerschool::PtpAssignmentSection.new(as_sec)
      end
    end

    def defaults
      {
        _assignmentsections: [],
        standardcalcdirection: 'NONE',
        standardscoringmethod: 'GradeScale'
    }
    end

    def to_hash(keys=nil)
      ivs = (keys ? (instance_variables & keys) : instance_variables)
      hash = {}
      ivs.each  do |var|
        value = case var
        when :@_assignmentsections
          instance_variable_get(var).map! {|as| as.to_hash}
        else
          instance_variable_get(var)
        end
        hash[var.to_s.delete("@")] = value
      end
      return hash
    end

    def to_json(*args)
      JSON.generate(to_hash)
    end

    alias_method :to_h, :to_hash

  end
end

# [
#   {
#     "_assignmentstandardassociations": [],
#     "createdbyplugin": "744",
#     "standardcalcdirection": "NONE",
#     "_name": "assignment",
#     "_assignmentsections": [],
#     "_id": 2477,
#     "hasstandards": false,
#     "assignmentid": 2477
#   }
# ]

