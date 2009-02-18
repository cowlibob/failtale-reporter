
module FailtaleReporter
  class Error
    
    attr_accessor :api_token
    attr_accessor :hash_string
    attr_accessor :name
    attr_accessor :reporter
    attr_accessor :description
    attr_accessor :properties
    attr_accessor :backtrace
    attr_accessor :environment
    
    def initialize(exception)
      self.api_token = FailtaleReporter.api_token
      self.reporter  = FailtaleReporter.default_reporter
      
      self.name = "#{exception.class} #{exception.message}"
      self.description = exception.message
      self.backtrace = FailtaleReporter.clean_backtrace(exception.backtrace).join("\n")
      self.environment = ENV.to_hash
      self.hash_string = Digest::SHA1.hexdigest(
        [exception.class, exception.backtrace.first].join('--')
      )
    end
    
    def to_param
      { :report =>
        { :project => {
          :api_token => self.api_token
        },:error => {
          :hash_string => self.hash_string
        },:occurence => {
          :name => self.name,
          :reporter => self.reporter,
          :description => self.description,
          :backtrace => self.backtrace,
          :properties => self.environment
        } }
      }
    end
    
  end
end
