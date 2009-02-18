
require 'digest/sha1'
begin
  httparty = Dir.glob(File.dirname(__FILE__)+'/../vendor/httparty-*/lib/httparty.rb').last
  httparty ||= 'httparty'
  require httparty
rescue LoadError
  retry if require 'rubygems'
end

module FailtaleReporter
  
  include HTTParty
  
  base_uri 'failtale.be'
  format :xml
  
  def self.load_adapter(name)
    require File.dirname(__FILE__)+"/failtale_reporter/adapters/#{name}"
  end
  
  class << self
    def reportable_exceptions(*arr)
      arr = [Exception] if (arr || []).empty?
      @reportable_exceptions ||= arr.flatten
    end
    def ignored_exceptions(*arr)
      @ignored_exceptions ||= arr.flatten
    end
    def api_token(token=nil)
      @api_token ||= token
    end
    def default_reporter(reporter=nil)
      @default_reporter = reporter if reporter
      @default_reporter
    end
    def application_root(path=nil)
      @application_root = backtrace_cleaner_regexp(path) if path
      @application_root
    end
    def configure
      yield self
    end
    def clean_backtrace(backtrace)
      backtrace.collect do |line|
        path = File.expand_path(line.split(':').first)
        if File.exist?(path)
          line = File.expand_path(line)
          cleaned_line = nil
          backtrace_cleaners.each do |proc|
            cleaned_line = proc.call(line)
            break if cleaned_line
          end
          cleaned_line || line
        else
          line
        end
      end
    end
    def backtrace_cleaners
      @backtrace_cleaners ||= []
    end
    def backtrace_cleaner(&block)
      backtrace_cleaners.push(block)
    end
    def backtrace_cleaner_regexp(path)
      Regexp.new("^#{Regexp.escape(File.expand_path(path))}")
    end
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
  
  default_reporter 'ruby'
  
  backtrace_cleaner do |line|
    if FailtaleReporter.application_root
      line.sub! FailtaleReporter.application_root, "[APP]"
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
  
  def self.report(error=nil, &block)
    Client.new.report(error, &block)
  end
  
end

require File.dirname(__FILE__)+'/failtale_reporter/error'
require File.dirname(__FILE__)+'/failtale_reporter/client'
