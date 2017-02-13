# -*- encoding: utf-8 -*-
# stub: hashdiff 0.3.0 ruby lib

Gem::Specification.new do |s|
  s.name = "hashdiff"
  s.version = "0.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Liu Fengyun"]
  s.date = "2016-02-11"
  s.description = " HashDiff is a diff lib to compute the smallest difference between two hashes. "
  s.email = ["liufengyunchina@gmail.com"]
  s.homepage = "https://github.com/liufengyun/hashdiff"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.7")
  s.rubygems_version = "2.1.11"
  s.summary = "HashDiff is a diff lib to compute the smallest difference between two hashes."

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, ["~> 2.0"])
      s.add_development_dependency(%q<yard>, [">= 0"])
      s.add_development_dependency(%q<bluecloth>, [">= 0"])
    else
      s.add_dependency(%q<rspec>, ["~> 2.0"])
      s.add_dependency(%q<yard>, [">= 0"])
      s.add_dependency(%q<bluecloth>, [">= 0"])
    end
  else
    s.add_dependency(%q<rspec>, ["~> 2.0"])
    s.add_dependency(%q<yard>, [">= 0"])
    s.add_dependency(%q<bluecloth>, [">= 0"])
  end
end
