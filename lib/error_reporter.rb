
begin
  require 'digest/sha1'
  require 'httparty'
rescue LoadError
  retry if require 'rubygems'
end

require File.dirname(__FILE__)+'/error_reporter/error'

module ErrorReporter
  
  include HTTParty
  
  base_uri 'errors.be'
  format :xml
  
  class << self
    def reportable_exceptions=(arr)
      @reportable_exceptions = [arr].flatten
    end
    def reportable_exceptions
      @reportable_exceptions ||= [Exception]
    end
    def api_token(token=nil)
      @api_token ||= token
    end
  end
  
  def self.report(error=nil)
    yield if block_given? and error.nil?
  rescue *(self.reportable_exceptions) => exception
    error = Error.new(exception)
  ensure
    post_report(error) unless error.nil?
    raise exception unless exception.nil?
  end
  
  def self.post_report(error)
    params = error.to_param
    params[:report][:project] = { :api_token => api_token }
    self.post('/reports.xml', :body => params)
  rescue Net::HTTPServerException => e
    p e
  end
  
end
