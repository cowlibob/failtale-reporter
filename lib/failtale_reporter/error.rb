class FailtaleReporter::Error

  attr_accessor :api_token
  attr_accessor :hash_string
  attr_accessor :name
  attr_accessor :reporter
  attr_accessor :description
  attr_accessor :properties
  attr_accessor :backtrace
  attr_accessor :environment
  attr_accessor :parameter_filter

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

    # Filter parameters before environment values are converted to strings
    self.parameter_filter = Regexp.new(FailtaleReporter.env_filter_words.collect{ |s| s.to_s }.join('|'), true) if FailtaleReporter.env_filter_words.length > 0
    self.environment = filter_parameters self.environment

    # convert environment children to strings
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

  private
  def filter_parameters unfiltered_parameters

    return unfiltered_parameters if self.parameter_filter.nil?
    filtered_parameters = {}

    unfiltered_parameters.each do |key, value|

      if key =~ self.parameter_filter
        filtered_parameters[key] = '[FILTERED]'
      elsif value.is_a?(Hash)
        filtered_parameters[key] = filter_parameters(value)
      elsif value.is_a?(Array)
        filtered_parameters[key] = value.collect do |item|
          case item
          when Hash, Array
            filter_parameters(item)
          else
            item
          end
        end
      elsif block_given?
        key = key.dup
        value = value.dup if value.duplicable?
        yield key, value
        filtered_parameters[key] = value
      else
        filtered_parameters[key] = value
      end
    end
    filtered_parameters
  end

end