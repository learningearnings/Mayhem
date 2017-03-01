module Powerschool
  class School < PowerschoolObject
    attr_accessor(:id, :name, :school_number, :state_province_id, :low_grade, :high_grade, :alternate_school_number)
    # Hashes
    attr_accessor(:addresses, :assistant_principal, :full_time_equivalencies, :phones, :principal, :school_boundary, :school_fees_setup, :school_fees_setup)

  end
end