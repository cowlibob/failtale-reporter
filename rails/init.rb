
::ErrorReporter.load_adapter('rails')
::ActionController::Base.send :include, ::ErrorReporter::Adapters::Rails
