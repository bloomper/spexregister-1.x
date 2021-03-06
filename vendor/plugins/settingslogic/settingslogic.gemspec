# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{settingslogic}
  s.version = "2.0.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ben Johnson of Binary Logic"]
  s.date = %q{2010-02-12}
  s.email = %q{bjohnson@binarylogic.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".gitignore",
     "CHANGELOG.rdoc",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION.yml",
     "init.rb",
     "lib/settingslogic.rb",
     "rails/init.rb",
     "settingslogic.gemspec",
     "spec/settings.rb",
     "spec/settings.yml",
     "spec/settings2.rb",
     "spec/settings3.rb",
     "spec/settingslogic_spec.rb",
     "spec/spec_helper.rb"
  ]
  s.homepage = %q{http://github.com/binarylogic/settingslogic}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{A simple and straightforward settings solution that uses an ERB enabled YAML file and a singleton design pattern.}
  s.test_files = [
    "spec/settings.rb",
     "spec/settings2.rb",
     "spec/settings3.rb",
     "spec/settingslogic_spec.rb",
     "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end

