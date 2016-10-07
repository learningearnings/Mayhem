class OtuCode < ActiveRecord::Base
  attr_accessible :points, :code, :student_id, :person_school_link_id, :expires_at, :ebuck, :student, :person_school_link, :otu_code_category_id, :redeemed_at
  has_many :transactions, :as => :commercial_document, :class_name => 'Plutus::Transaction'
  has_many :buck_batches, :through => :buck_batch_links
  has_many :buck_batch_links
  belongs_to :student
  belongs_to :person_school_link
  has_one :teacher, :through => :person_school_link, :source => :person
  has_one :school, :through => :person_school_link
  has_many :messages, :through => :message_code_links
  has_many :message_code_links
  belongs_to :otu_code_category

  before_validation :generate_code, on: :create

  validates :code, presence: true, uniqueness: true

  scope :active, where("active = ?", true)
  scope :inactive, where("active = ?", false)
  scope :not_expired, lambda { where("created_at > ?", Time.now - 90.days)}
  scope :ebuck, where(ebuck: true)
  scope :last_30, lambda { where(OtuCode.arel_table[:created_at].gt(Time.now - 30.days)) }
  scope :for_school, lambda { |school| joins(:person_school_link).where({:person_school_link => {school_id: school.id} } ) }
  scope :for_grade, lambda { |grade| joins(:student).where(student: {grade: grade})}
  scope :redeemed_between, lambda { |start_date, end_date|
    where(OtuCode.arel_table[:redeemed_at].gteq(start_date)).
    where(OtuCode.arel_table[:redeemed_at].lteq(end_date))
  }
  scope :created_between, lambda { |start_date, end_date|
    where(OtuCode.arel_table[:created_at].gteq(start_date)).
    where(OtuCode.arel_table[:created_at].lteq(end_date))
  }
  scope :total_credited, lambda { |student_id,start_date, end_date|
    where("student_id = ? AND updated_at >= ? AND updated_at <= ?",student_id, start_date, end_date)
  }
  def expired?
    self.expires_at <= Time.now
  end

  def is_ebuck?
    ebuck?
  end

  def generate_code
    begin
      self.code = SecureRandom.hex(4)[0..6].upcase
    end while self.class.exists?(code: code)
  end

  def source_string
    if teacher
      teacher.to_s
    elsif is_game?
      source_string_for_game
    else
      ''
    end
  end

  def is_game?
    source_string_for_game.present?
  end

  def prefix
    code[0..1]
  end

  def source_string_for_game
    games = {
      FF: 'Food Fight'
    }
    games[prefix.to_sym]
  end

  def mark_redeemed!
    # Don't run validations, because legacy codes are not unique.
    self.active = false
    self.redeemed_at = Time.zone.now
    self.save(validate: false)
  end
end
