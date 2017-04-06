module Powerschool
  class PtpAssignmentSection
    attr_accessor(:_id, :_assignmentstudentassociations, :publishonspecificdate, :isscorespublish, :description, :publisheddate,
                  :weight, :isscoringneeded, :publishdaysbeforedue, :scoreentrypoints, :sectionsdcid, :totalpointvalue,
                  :publishoption, :maxretakeallowed, :assignmentsectionid, :iscountedinfinalgrade, :duedate, :extracreditpoints,
                  :name, :scoretype, :_assignmentcategoryassociations, :_onlinework)

    def initialize(values={})
      values = defaults.merge(values)
      values.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
    end

    def defaults
      {
        scoretype: "POINTS",
        scoreentrypoints: 100,
        extracreditpoints: 0,
        isextracredit: false,
        weight: 1,
        totalpointvalue: 100,
        iscountedinfinalgrade: true,
        publishoption: "Never",
        # publishdaysbeforedue: nil,
        # publishonspecificdate: nil,
        isscorespublish: true,
        maxretakeallowed: 0,
        _assignmentStudentAssociations: [],
        _assignmentcategoryassociations: []
      }
    end

    def to_hash(keys=nil)
      ivs = (keys ? (instance_variables & keys) : instance_variables)
      hash = {}
      ivs.each  do |var|
        hash[var.to_s.delete("@")] = instance_variable_get(var)
      end
      hash
    end
  end
end

