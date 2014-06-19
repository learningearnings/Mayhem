# This model is used to track login events, this is not a user model
class LoginEvent < ActiveRecord::Base
  attr_accessible :school_id, :user_id, :user_type

  scope :created_between, lambda { |start_date, end_date| 
    where(arel_table[:created_at].gteq(start_date)).
    where(arel_table[:created_at].lteq(end_date))
  }
end
