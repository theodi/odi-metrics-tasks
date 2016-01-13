lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

Gem::Specification.new do |s|
  s.name        = "odi-metrics-tasks"
  s.version     = "0.1.0"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["James Smith", "Sam Pikesley", "Tom Heath", "Stuart Harrison"]
  s.email       = ["tech@theodi.org"]
  s.homepage    = "http://github.com/theodi/odi-metrics-tasks"
  s.summary     = "Resque tasks for ODI metrics collection"

  s.required_rubygems_version = ">= 1.8.24"

  s.add_dependency 'rake'               , '~> 10.0', '>= 10.0.3'
  s.add_dependency 'resque'             , '~> 1.23', '>= 1.23.0'
  s.add_dependency 'github_api'         , '~> 0.12', '>= 0.12.2'
  s.add_dependency 'activemodel'        , '~> 3.2' , '>= 3.2.12'
  s.add_dependency 'ruby-trello'        , '~> 1.3.0' # last one that supports Ruby <2
  s.add_dependency 'capsulecrm'
  s.add_dependency 'fog'                , '~> 1.12', '>= 1.12.1'
  s.add_dependency 'httparty'
  s.add_dependency 'google-api-client'  , '>= 0.7.0'
  s.add_dependency 'curb'               , '~> 0.8' , '>= 0.8.6'

  s.add_development_dependency 'coveralls'
  s.add_development_dependency 'cucumber'         , '~> 1.2'
  s.add_development_dependency 'dotenv'           , '~> 0.5'
  s.add_development_dependency 'guard-cucumber'   , '~> 1.3'
  s.add_development_dependency 'guard-spork'      , '~> 1.4'
  s.add_development_dependency 'pry'              , '~> 0.9'
  s.add_development_dependency 'rb-fsevent'       , '~> 0.9'
  s.add_development_dependency 'rspec'            , '~> 2.12'
  s.add_development_dependency 'timecop'          , '~> 0.5'
  s.add_development_dependency 'vcr'              , '~> 2.9'
  s.add_development_dependency 'webmock'          , '1.9.3'

  s.files        = Dir.glob("{lib}/**/*") + %w(LICENSE.md README.md)
  s.require_path = 'lib'
end
