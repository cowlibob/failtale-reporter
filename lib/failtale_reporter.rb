
begin
  require 'digest/sha1'
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
    def configure
      yield self
    end
  end
  
  default_reporter 'ruby'
  
  def self.report(error=nil, &block)
    Client.new.report(error, &block)
  end
  
end

require File.dirname(__FILE__)+'/failtale_reporter/error'
require File.dirname(__FILE__)+'/failtale_reporter/client'
