
module ErrorReporter
  module Adapters
    
    module Rails
      
      IGNORED_EXCEPTIONS = [ActiveRecord::RecordNotFound,
                            ActionController::RoutingError,
                            ActionController::InvalidAuthenticityToken,
                            CGI::Session::CookieStore::TamperedWithCookie]
      
      def self.included(target)
        target.send :alias_method_chain, :rescue_action_in_public, :errors
        
        ErrorReporter.configure do |config|
          config.ignored_exceptions IGNORED_EXCEPTIONS
        end
      end
      
      def rescue_action_in_public_with_errors(exception)
        is_private = ::Rails.env.development? or ::Rails.env.test?
        ErrorReporter.report(exception) unless is_private
        rescue_action_in_public_without_errors(exception)
      end
      
    end
    
  end
end

::ActionController::Base.send :include, ErrorReporter::Adapters::Rails
