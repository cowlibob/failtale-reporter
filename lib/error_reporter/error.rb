
module ErrorReporter
  class Error
    
    attr_accessor :hash_string
    attr_accessor :name
    attr_accessor :description
    attr_accessor :properties
    attr_accessor :backtrace
    attr_accessor :environment
    
    def initialize(exception)
      self.name = "#{exception.class} raised at #{exception.backtrace.first}"
      self.hash_string = Digest::SHA1.hexdigest(self.name)
      self.description = exception.message
      self.backtrace = exception.backtrace.join("\n")
      self.properties = {}
      self.environment = { :application => $0 }
    end
    
    def to_param
      { :report =>
        { :error => {
          :name => self.name,
          :hash_string => self.hash_string,
          :description => self.description,
          :backtrace => self.backtrace,
          :properties => self.properties
        },:occurence => {
          :properties => self.environment
        } }
      }
    end
    
  end
end
