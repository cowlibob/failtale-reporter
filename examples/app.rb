
require File.dirname(__FILE__)+'/../lib/error_reporter'

ErrorReporter.base_uri  'errors.dev'
ErrorReporter.api_token 'd1afb8e60b1f63ec12c7c4508a9044d41ae2c282'
ErrorReporter.report do
  raise 'Hello'
end
