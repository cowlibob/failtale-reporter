module FailtaleReporter::Adapters

  def load_adapter(name)
    require "failtale_reporter/adapters/#{name}"
  end

end