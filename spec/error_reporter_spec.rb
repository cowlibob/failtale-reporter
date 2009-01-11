
describe "ErrorReporter" do
  
  it "should send error reports" do
    ErrorReporter.should_receive(:post).with('/reports.xml', an_instance_of(Hash))
    lambda do
      ErrorReporter.report do
        raise "hello"
      end
    end.should raise_error(RuntimeError, "hello")
  end
  
  it "should send error reports for selected exceptions" do
    ErrorReporter.should_receive(:post).with('/reports.xml', an_instance_of(Hash))
    ErrorReporter.reportable_exceptions ArgumentError
    lambda do
      ErrorReporter.report do
        raise ArgumentError, "hello"
      end
    end.should raise_error(ArgumentError, "hello")
  end
  
  it "should not send error reports for non-selected exceptions" do
    ErrorReporter.should_not_receive(:post)
    ErrorReporter.reportable_exceptions ArgumentError
    lambda do
      ErrorReporter.report do
        raise RuntimeError, "hello"
      end
    end.should raise_error(RuntimeError, "hello")
  end
  
end
