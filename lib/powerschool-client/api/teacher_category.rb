module Powerschool
  class TeacherCategory
    attr_accessor(:isinfinalgrades, :_name, :color, :_categoryschoolexcludeassociations, :_breach_mitigation, :teachercategoryid, :isactive,
                  :_teachercategorysectionexcludeassociations, :usersdcid, :categorytype, :defaulttotalvalue, :displayposition, :isdefaultpublishscores,
                  :districtteachercategoryid, :defaultweight, :name,:_id, :teachermodified, :defaultpublishoption, :isusermodifiable)

    def initialize(values={})
      values.each do |key, value|
        # remove characters that can't be in a variable name &downcase the first character is neccessary
        k = key.gsub(/[^a-zA-Z0-9_]/, '_').sub(/^[A-Z]/, &:downcase)
        instance_variable_set("@#{k}", value)
      end
    end

  end
end