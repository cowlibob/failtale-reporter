
require File.dirname(__FILE__)+'/../lib/error_reporter'

ErrorReporter.configure do |config|
  config.base_uri  'errors.dev'
  config.api_token 'd1afb8e60b1f63ec12c7c4508a9044d41ae2c282'
end

ErrorReporter.report do
  raise 'Hello'
end
