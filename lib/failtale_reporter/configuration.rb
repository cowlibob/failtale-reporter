module FailtaleReporter::Configuration

  def reportable_exceptions(*arr)
    arr = [Exception] if (arr || []).empty?
    @reportable_exceptions ||= arr.flatten
  end

  def ignored_exceptions(*arr)
    @ignored_exceptions ||= arr.flatten
  end

  def api_token(token=nil)
    @api_token ||= token
  end

  def default_reporter(reporter=nil)
    @default_reporter = reporter if reporter
    @default_reporter
  end

  def application_root(path=nil)
    @application_root = backtrace_cleaner_regexp(path) if path
    @application_root
  end

  def configure
    yield self
  end

end