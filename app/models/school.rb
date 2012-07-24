class School < ActiveRecord::Base
  attr_accessible :ad_profile, :school_address_id, :distribution_model, :gmt_offset, :logo_name, :logo_uid, :mascot_name, :max_grade, :min_grade, :name, :school_demo, :school_mail_to, :school_phone, :school_type_id, :status, :timezone
end
