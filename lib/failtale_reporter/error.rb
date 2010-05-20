class FailtaleReporter::Error

  attr_accessor :api_token
  attr_accessor :hash_string
  attr_accessor :name
  attr_accessor :reporter
  attr_accessor :description
  attr_accessor :properties
  attr_accessor :backtrace
  attr_accessor :environment

  def initialize(exception, ctxs=[])
    self.api_token = FailtaleReporter.api_token
    self.reporter  = FailtaleReporter.default_reporter

    self.name = "#{exception.class} #{exception.message}"
    self.description = exception.message
    self.backtrace = FailtaleReporter.clean_backtrace(exception.backtrace).join("\n")
    self.environment = ENV.to_hash
    self.hash_string = Digest::SHA1.hexdigest(
      [exception.class, exception.backtrace.first].join('--')
    )
    FailtaleReporter.collect_information(self, ctxs)

    self.backtrace = self.backtrace.inspect unless self.backtrace.is_a? String
    self.environment = self.environment.inject({}) do |m,(k,v)|
      k = k.inspect unless k.is_a? String
      v = v.inspect unless v.is_a? String
      m[k] = v
      m
    end
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