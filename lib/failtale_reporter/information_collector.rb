module FailtaleReporter::InformationCollector

  def collect_information(error, ctxs)
    information_collectors.each do |proc|
      proc.call(error, *ctxs)
    end
  end

  def information_collectors
    @information_collectors ||= []
  end

  def information_collector(&block)
    information_collectors.push(block)
  end

end