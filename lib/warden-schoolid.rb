require "warden-schoolid/version"
require "warden-schoolid/config"
require "warden-schoolid/schoolid"

Warden::Strategies.add(:schoolid, Warden::SchoolId::Strategy)
