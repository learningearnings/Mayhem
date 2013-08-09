class State < ActiveRecord::Base
  attr_accessible :abbr, :name

  has_many :state_filter_links, :inverse_of => :states
  has_many :filters, :through => :state_filter_links
  has_many :school_addresses
  has_many :auctions, :through => :auction_state_links
  has_many :auction_state_links

  has_many :state_product_links
  has_many :products, :through => :state_product_links, :class_name => "Spree::Product", :source => :spree_product

  validates_uniqueness_of :abbr
end
