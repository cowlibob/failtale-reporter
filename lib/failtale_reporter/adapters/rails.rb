
module FailtaleReporter
  module Adapters
    
    module Rails
      
      IGNORED_EXCEPTIONS = [ActiveRecord::RecordNotFound,
                            ActionController::RoutingError,
                            ActionController::InvalidAuthenticityToken,
                            CGI::Session::CookieStore::TamperedWithCookie]
      
      def self.included(target)
        target.send :alias_method_chain, :rescue_action_in_public, :errors
        
        FailtaleReporter.configure do |config|
          config.ignored_exceptions IGNORED_EXCEPTIONS
          config.default_reporter "rails"
        end
      end
      
      def rescue_action_in_public_with_errors(exception)
        is_private = ::Rails.env.development? or ::Rails.env.test?
        FailtaleReporter.report(exception) unless is_private
        rescue_action_in_public_without_errors(exception)
      end
      
    end
    
  end
end

::ActionController::Base.send :include, FailtaleReporter::Adapters::Rails
