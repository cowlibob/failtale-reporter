
module FailtaleReporter

  def self.force_public(flag=nil)
    @force_public = flag unless flag.nil?
    @force_public
  end

end

module FailtaleReporter::Adapters::Rails

  IGNORED_EXCEPTIONS = ['ActiveRecord::RecordNotFound',
                        'ActionController::RoutingError',
                        'ActionController::InvalidAuthenticityToken',
                        'CGI::Session::CookieStore::TamperedWithCookie']

  IGNORED_EXCEPTIONS.map!{|e| eval(e) rescue nil }.compact!
  IGNORED_EXCEPTIONS.freeze

  def self.included(target)
    target.send :alias_method_chain, :rescue_action, :failtale

    FailtaleReporter.configure do |config|
      config.ignored_exceptions IGNORED_EXCEPTIONS
      config.default_reporter "rails"
      config.application_root Rails.root
      config.information_collector do |error, controller|
        env = error.environment
        env = env.merge(controller.request.env)

        env.delete('action_controller.rescue.response')
        env.delete('action_controller.rescue.request')
        error.environment = env
      end
    end
  end

  def rescue_action_with_failtale(exception)
    FailtaleReporter.report(exception, self) unless is_private?
    rescue_action_without_failtale(exception)
  end

protected

  def is_private?
    !FailtaleReporter.force_public and %w(development test).include?(Rails.env)
  end

end

::ActionController::Base.send :include, FailtaleReporter::Adapters::Rails
