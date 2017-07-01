module Powerschool
  class PtpAssignmentScore
    attr_accessor(:islate, :scorepoints, :_name, :isexempt, :studentsdcid, :scorelettergrade, :ismissing,
                  :isabsent, :isincomplete, :iscollected, :actualscorekind, :scoreentrydate, :actualscoreentered,
                  :actualscoregradescaledcid, :_id, :id, :scorepercent, :_assignmentsection, :_assignmentscorecomment)


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
        islate: false,
        isincomplete: false,
        iscollected: false,
        ismissing: false,
        isabsent: false,
        isexempt: false,
        actualscorekind: "REAL_SCORE",
        IsScoresPublish: true,
        maxretakeallowed: 0,
        _assignmentStudentAssociations: [],
        _assignmentcategoryassociations: [],
        _assignmentscorecomment: {},
        _assignmentsection: {}
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
