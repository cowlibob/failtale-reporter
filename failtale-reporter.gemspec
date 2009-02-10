# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{failtale-reporter}
  s.version = "0.0.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Simon Menke"]
  s.date = %q{2009-02-10}
  s.email = %q{simon.menke@gmail.com}
  s.files = ["lib/failtale-reporter.rb", "lib/failtale_reporter/adapters/rails.rb", "lib/failtale_reporter/client.rb", "lib/failtale_reporter/error.rb", "lib/failtale_reporter.rb", "lib/mrhenry-failtale-reporter.rb", "rails/init.rb", "tasks/failtale.rake", "spec/error_reporter_spec.rb", "spec/error_spec.rb", "README.textile"]
  s.homepage = %q{http://github.com/mrhenry}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{failtale-reporter}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{A Ruby error reporter for our failtale service}
  s.test_files = ["spec/error_reporter_spec.rb", "spec/error_spec.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<httparty>, [">= 0.3.0"])
    else
      s.add_dependency(%q<httparty>, [">= 0.3.0"])
    end
  else
    s.add_dependency(%q<httparty>, [">= 0.3.0"])
  end
end
