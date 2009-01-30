
require File.dirname(__FILE__)+'/../lib/failtale_reporter'

describe "ErrorReporter::Error" do
  
  describe "#to_param" do
    
    it "should generate valid data" do
      begin
        raise "hello"
      rescue Exception => exception
        error = ErrorReporter::Error.new(exception)
        
        error.backtrace.should   be_eql(exception.backtrace.join("\n"))
        error.description.should be_eql(exception.message)
        error.name.should        be_eql("#{exception.class} raised at #{exception.backtrace.first}")
      end
    end
    
  end
  
end
