
namespace :failtale do

  desc 'Test failtale configuration'
  task :test => :environment do
    class ::FailtaleReporter::TestError < Exception ; end
    FailtaleReporter.report do
      raise FailtaleReporter::TestError, 'Test exception'
    end
  end
  
  desc 'Freeze Failtale reporter'
  task :freeze do
    vendor_dir = File.expand_path('./vendor/plugins')
    sh %{mkdir -p "#{vendor_dir}"}
    Dir.chdir vendor_dir do
      sh %{gem unpack mrhenry-failtale-reporter}
      sh %{mv mrhenry-failtale-reporter-* failtale-reporter}
      sh %{cp failtale-reporter/rails/init.rb failtale-reporter/init.rb}
    end
  end
  
  desc 'Unfreeze Failtale reporter'
  task :unfreeze do
    vendor_dir = File.expand_path('./vendor/plugins')
    sh %{rm -rf #{vendor_dir}/failtale-reporter}
  end
  
  namespace :httparty do
    
    desc 'Freeze HTTParty'
    task :freeze do
      unless __FILE__.include? "vendor/plugins/failtale-reporter"
        puts "Failtale is not installed as a plugin!"
        exit(1)
      end
      vendor_dir = File.dirname(__FILE__)+'/../vendor'
      sh %{mkdir -p "#{vendor_dir}"}
      Dir.chdir vendor_dir do
        sh %{gem unpack httparty}
      end
    end
    
    desc 'Unfreeze HTTParty'
    task :unfreeze do
      unless __FILE__.include? "vendor/plugins/failtale-reporter"
        puts "Failtale is not installed as a plugin!"
        exit(1)
      end
      vendor_dir = File.dirname(__FILE__)+'/../vendor'
      sh %{rm -rf "#{vendor_dir}"}
    end
    
  end
  
end
