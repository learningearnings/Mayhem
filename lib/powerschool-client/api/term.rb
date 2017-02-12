module Powerschool
  class Term < PowerschoolObject
    attr_accessor(:id, :school_id, :start_year, :portion, :start_date, :end_date, :abbreviation, :name)

  end
end