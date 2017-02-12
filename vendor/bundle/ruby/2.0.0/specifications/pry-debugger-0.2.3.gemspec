# -*- encoding: utf-8 -*-
# stub: pry-debugger 0.2.3 ruby lib

Gem::Specification.new do |s|
  s.name = "pry-debugger"
  s.version = "0.2.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Gopal Patel"]
  s.date = "2014-07-02"
  s.description = "Combine 'pry' with 'debugger'. Adds 'step', 'next', and 'continue' commands to control execution."
  s.email = "nixme@stillhope.com"
  s.homepage = "https://github.com/nixme/pry-debugger"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.2")
  s.rubygems_version = "2.1.11"
  s.summary = "Fast debugging with Pry."

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<pry>, ["< 0.11.0", ">= 0.9.10"])
      s.add_runtime_dependency(%q<debugger>, ["~> 1.3"])
      s.add_development_dependency(%q<pry-remote>, ["~> 0.1.6"])
    else
      s.add_dependency(%q<pry>, ["< 0.11.0", ">= 0.9.10"])
      s.add_dependency(%q<debugger>, ["~> 1.3"])
      s.add_dependency(%q<pry-remote>, ["~> 0.1.6"])
    end
  else
    s.add_dependency(%q<pry>, ["< 0.11.0", ">= 0.9.10"])
    s.add_dependency(%q<debugger>, ["~> 1.3"])
    s.add_dependency(%q<pry-remote>, ["~> 0.1.6"])
  end
end
