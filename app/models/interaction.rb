class Interaction < ActiveRecord::Base
  belongs_to :person
  before_create :set_defaults

  attr_accessible :ip_address, :person_id, :created_at

  scope :between, lambda {|start_date, end_date| 
    where(Interaction.arel_table[:created_at].gteq(start_date).
      and(Interaction.arel_table[:created_at].lteq(end_date)))} 
  scope :student_login_between, lambda {|start_date, end_date| 
    where(Interaction.arel_table[:created_at].gteq(start_date).
      and(Interaction.arel_table[:created_at].lteq(end_date)).
      and(Interaction.arel_table[:page].eq("/students/home")))}
  scope :staff_login_between, lambda {|start_date, end_date| 
    where(Interaction.arel_table[:created_at].gteq(start_date).
      and(Interaction.arel_table[:created_at].lteq(end_date)).
      and(Interaction.arel_table[:page].eq("/teachers/home")))}

  protected
  def set_defaults
    self.date ||= Time.zone.now.to_date
  end
end
