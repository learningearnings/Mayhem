class SchoolsImporter < ImporterBase
  # TODO: Will need to handle importing the status of the school if that is
  # still required.

  def header_mapping
    {
      name: 'school',
      school_type_id: 'schooltypeID',
      min_grade: 'min_grade',
      max_grade: 'max_grade',
      school_phone: 'schoolphone',
      school_mail_to: 'schoolmailto',
      mascot_name: 'mascot_name',
      school_demo: 'schooldemo',
      timezone: 'timezone',
      gmt_offset: 'gmtoffset',
      distribution_model: 'distribution_model'
    }
  end

  def address_header_mapping
    {
      line1: 'schooladdress',
      line2: 'schooladdress2',
      city: 'cityID',
      state_id: 'stateID',
      zip: 'schoolzip',
      latitude: 'lat',
      longitude: 'lon'
    }
  end

  def model_class
    School
  end

  def associated_many_classes
    [Address]
  end
end

