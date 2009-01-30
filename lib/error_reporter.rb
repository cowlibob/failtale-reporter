
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
  
  def self.load_adapter(name)
    require File.dirname(__FILE__)+"/error_reporter/adapters/#{name}"
  end
  
  class << self
    def reportable_exceptions(*arr)
      arr = [Exception] if arr.empty?
      @reportable_exceptions ||= arr.flatten
    end
    def ignored_exceptions(*arr)
      @ignored_exceptions ||= arr.flatten
    end
    def api_token(token=nil)
      @api_token ||= token
    end
    def configure
      yield self
    end
  end
  
  def self.report(error=nil)
    error = handle_exception(error)
    yield if block_given? and error.nil?
  rescue Exception => exception
    error = handle_exception(exception)
  ensure
    post_report(error) unless error.nil?
    raise exception unless exception.nil?
  end
  
  def self.handle_exception(exception)
    return exception if exception.nil?
    return exception if exception.is_a? ErrorReporter::Error
    return nil unless reportable_exceptions.any? {|c| exception.is_a? c }
    return nil if     ignored_exceptions.any?    {|c| exception.is_a? c }
    Error.new(exception)
  end
  
  def self.post_report(error)
    params = error.to_param
    params[:report][:project] = { :api_token => api_token }
    self.post('/reports.xml', :body => params)
  end
  
end
