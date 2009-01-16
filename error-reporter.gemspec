# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{error-reporter}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Simon Menke"]
  s.date = %q{2009-01-16}
  s.email = %q{simon.menke@gmail.com}
  s.files = ["README.textile", "lib/error-reporter.rb", "lib/error_reporter/adapters/rails.rb", "lib/error_reporter/error.rb", "lib/error_reporter.rb", "lib/mrhenry-error-reporter.rb", "rails/init.rb", "spec/error_reporter_spec.rb", "spec/error_spec.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/mrhenry}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{error-reporter}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{A Ruby error reporter for our errors service}
  s.test_files = ["spec/error_reporter_spec.rb", "spec/error_spec.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<httparty>, [">= 0.2.6"])
    else
      s.add_dependency(%q<httparty>, [">= 0.2.6"])
    end
  else
    s.add_dependency(%q<httparty>, [">= 0.2.6"])
  end
end
