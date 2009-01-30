
module FailtaleReporter
  class Error
    
    attr_accessor :hash_string
    attr_accessor :name
    attr_accessor :description
    attr_accessor :properties
    attr_accessor :backtrace
    attr_accessor :environment
    
    def initialize(exception)
      self.name = "#{exception.class} #{exception.message}"
      self.description = exception.message
      self.backtrace = exception.backtrace.join("\n")
      self.environment = { :application => $0 }
      self.hash_string = Digest::SHA1.hexdigest(
        [exception.class, exception.message, exception.backtrace.first].join('--')
      )
    end
    
    def to_param
      { :report =>
        { :error => {
          :hash_string => self.hash_string
        },:occurence => {
          :name => self.name,
          :description => self.description,
          :backtrace => self.backtrace,
          :properties => self.environment
        } }
      }
    end
    
  end
end
