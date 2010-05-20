module FailtaleReporter::BacktraceCleaner

  def clean_backtrace(backtrace)
    backtrace.collect do |line|
      path = File.expand_path(line.split(':').first)
      if File.exist?(path)
        line = File.expand_path(line)
        cleaned_line = nil
        backtrace_cleaners.each do |proc|
          cleaned_line = proc.call(line)
          break if cleaned_line
        end
        cleaned_line || line
      else
        line
      end
    end
  end

  def backtrace_cleaners
    @backtrace_cleaners ||= []
  end

  def backtrace_cleaner(&block)
    backtrace_cleaners.push(block)
  end

  def backtrace_cleaner_regexp(path)
    Regexp.new("^#{Regexp.escape(File.expand_path(path))}")
  end

end