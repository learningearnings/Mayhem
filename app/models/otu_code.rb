class OtuCode < ActiveRecord::Base
  attr_accessible :points, :code, :student_id, :person_school_link_id, :expires_at, :ebuck, :student, :person_school_link
  has_many :transactions, :through => :otu_transaction_links
  has_many :buck_batches, :through => :buck_batch_links
  has_many :buck_batch_links
  belongs_to :student
  belongs_to :person_school_link
  has_one :teacher, :through => :person_school_link, :source => :person
  has_one :school, :through => :person_school_link
  has_many :messages, :through => :message_code_links
  has_many :message_code_links

  scope :active, where("active = ?", true)
  scope :not_expired, lambda { where("created_at > ?", Time.now - 45.days)}
  scope :ebuck, where(ebuck: true)

  def expired?
    self.created_at > (Time.now + 45.days)
  end

  def is_ebuck?
    ebuck?
  end

  def generate_code(prefix)
    _code = Code.active[rand(Code.active.count)] || Code.create
    _full_code = prefix + _code.code
    self.update_attribute(:code, _full_code)
    _code.update_attributes(:active => false, :used_date => Time.now)
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
    self.active = false
    self.redeemed_at = Time.zone.now
    self.save
  end
end
