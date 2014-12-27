$:.unshift File.join( File.dirname(__FILE__), "lib")

require 'rubygems'
require 'cucumber'
require 'cucumber/rake/task'
require 'rspec/core/rake_task'
require 'coveralls/rake/task'

RSpec::Core::RakeTask.new(:spec)

Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "features --format pretty"
end

Coveralls::RakeTask.new

task :default => [:spec, :features, :'coveralls:push']