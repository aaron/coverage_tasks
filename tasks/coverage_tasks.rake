begin
  require 'rcov'
  require 'rcov/rcovtask'

  namespace :coverage do
    
    COVERAGE_DIRECTORY = 'coverage'
    UNIT_DIRECTORY = COVERAGE_DIRECTORY + '/unit'
    FUNCTIONAL_DIRECTORY = COVERAGE_DIRECTORY + '/functional'
    ALL_DIRECTORY = COVERAGE_DIRECTORY + '/all'
    BASE_OPTIONS = ["--sort #{ENV['SORT'] || 'coverage'}", "--html", "--rails"]
  
    desc "Generate and open unit coverage report"
    Rcov::RcovTask.new(:do_units) do |t|
      FileUtils.mkdir_p(UNIT_DIRECTORY) unless File.directory?(UNIT_DIRECTORY)
      t.test_files = FileList['test/unit/*_test.rb']
      t.rcov_opts = BASE_OPTIONS + ["--exclude /gems/,/Library/,/controllers/,/helpers/"]
      t.output_dir = UNIT_DIRECTORY
    end
  
    desc "Generate and open unit coverage report"
    task :units => ['do_units'] do
      open_in_browser(UNIT_DIRECTORY)
    end
    
    desc "Generate and open functional coverage report"
    Rcov::RcovTask.new(:do_functionals) do |t|
      FileUtils.mkdir_p(FUNCTIONAL_DIRECTORY) unless File.directory?(FUNCTIONAL_DIRECTORY)
      t.test_files = FileList['test/functional/*_test.rb']
      t.rcov_opts = BASE_OPTIONS + ["--exclude /gems/,/Library/,/models/"]
      t.output_dir = FUNCTIONAL_DIRECTORY
    end
  
    desc "Generate and open functional coverage report"
    task :functionals => ['do_functionals'] do
      open_in_browser(FUNCTIONAL_DIRECTORY)
    end
    
    desc "Generate and open full coverage report"
    Rcov::RcovTask.new(:do_all) do |t|
      FileUtils.mkdir_p(ALL_DIRECTORY) unless File.directory?(ALL_DIRECTORY)
      t.test_files = FileList['test/unit/*_test.rb'] + FileList['test/functional/*_test.rb']
      t.rcov_opts = BASE_OPTIONS + ["--exclude /gems/,/Library/"]
      t.output_dir = ALL_DIRECTORY
    end
  
    desc "Generate and open full coverage report"
    task :all => ['do_all'] do
      open_in_browser(ALL_DIRECTORY)
    end
    
  end

rescue MissingSourceFile => e
  raise unless e.to_s == "no such file to load -- rcov"
end

def open_in_browser(directory)
  file = directory + '/index.html'
  if PLATFORM['darwin'] #Mac
    system("open #{file}") 
  elsif PLATFORM[/linux/] #Ubuntu, etc.
    system("/etc/alternatives/x-www-browser #{file}")
  end
end