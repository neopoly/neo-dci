require 'bundler/setup'
require 'bundler/gem_tasks'

task :default => :test

require 'rake/testtask'
Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/**/*_test.rb']
  t.verbose = true
end

# RDoc
require 'rdoc/task'
RDoc::Task.new do |rdoc|
  rdoc.title    = "Neo::DCI"
  rdoc.rdoc_dir = 'rdoc'
  rdoc.main     = 'README.md'
  rdoc.rdoc_files.include('README.md', 'lib/**/*.rb')
end
