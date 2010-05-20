class FailtaleReporter::Client

  def report(error=nil, *ctxs)
    error = handle_exception(error, ctxs)
    yield if block_given? and error.nil?
  rescue Exception => exception
    error = handle_exception(exception, ctxs)
  ensure
    post_report(error) unless error.nil?
    raise exception unless exception.nil?
  end

private

  def handle_exception(exception, ctxs)
    return exception if exception.is_a? FailtaleReporter::Error
    return nil if     exception.nil?
    return nil unless FailtaleReporter.reportable_exceptions.any? {|c| exception.is_a? c }
    return nil if     FailtaleReporter.ignored_exceptions.any?    {|c| exception.is_a? c }
    FailtaleReporter::Error.new(exception, ctxs)
  rescue Exception => e
    puts "#{e.class}: #{e.message}"
    puts e.backtrace
  end

  def post_report(error)
    response = FailtaleReporter.post('/reports.xml', :body => error.to_param)
  end

end