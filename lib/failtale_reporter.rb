module FailtaleReporter

  require 'digest/sha1'
  require 'httparty'

  require 'failtale_reporter/version'
  require 'failtale_reporter/error'
  require 'failtale_reporter/client'
  require 'failtale_reporter/configuration'
  require 'failtale_reporter/backtrace_cleaner'
  require 'failtale_reporter/information_collector'
  require 'failtale_reporter/adapters'


  include HTTParty
  extend FailtaleReporter::Adapters
  extend FailtaleReporter::Configuration
  extend FailtaleReporter::BacktraceCleaner
  extend FailtaleReporter::InformationCollector

  base_uri 'failtale.be'
  format :xml

  default_reporter 'ruby'

  backtrace_cleaner do |line|
    if FailtaleReporter.application_root
      line.sub! FailtaleReporter.application_root, "[APP]"
    end
  end

  if defined?(Gem)
    class << self
      def gem_backtrace_cleaner(spec)
        @gem_backtrace_cleaner ||= {}
        unless @gem_backtrace_cleaner[spec.full_name]
          @gem_backtrace_cleaner[spec.full_name] = {
            :regexp => backtrace_cleaner_regexp(spec.full_gem_path),
            :label  => "[GEM: #{spec.name} @#{spec.version.to_s}]"
          }
        end
        @gem_backtrace_cleaner[spec.full_name]
      end
    end
    backtrace_cleaner do |line|
      cleaned_line = nil
      Gem.loaded_specs.values.each do |spec|
        options = FailtaleReporter.gem_backtrace_cleaner(spec)
        cleaned_line = line.sub!(options[:regexp], options[:label])
        break if cleaned_line
      end
      cleaned_line
    end
  end

  def self.report(error=nil, *ctxs, &block)
    Client.new.report(error, *ctxs, &block)
  end

end