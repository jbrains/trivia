require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

require 'rake/testtask'
Rake::TestTask.new("minitest") do |t|
  t.libs.push "lib"
  t.libs.push "test"
  t.test_files = FileList['test/*_test.rb']
end

