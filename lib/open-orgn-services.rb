class Hash
  def compact
    delete_if { |k, v| !v }
  end
end

require 'resque'

# Setup redis server
raise "Redis configuration not set" unless ENV['RESQUE_REDIS_HOST'] && ENV['RESQUE_REDIS_PORT']
Resque.redis = Redis.new(
  :host => ENV['RESQUE_REDIS_HOST'], 
  :port => ENV['RESQUE_REDIS_PORT'], 
  :password => (ENV['RESQUE_REDIS_PASSWORD'].nil? || ENV['RESQUE_REDIS_PASSWORD']=='' ? nil : ENV['RESQUE_REDIS_PASSWORD'])
)

# Configure CapsuleCRM connection
require 'capsulecrm'
CapsuleCRM.account_name = ENV['CAPSULECRM_ACCOUNT_NAME']
CapsuleCRM.api_token = ENV['CAPSULECRM_API_TOKEN']
CapsuleCRM.initialize!


require 'xeroizer'

require 'eventbrite-client'
require 'eventbrite/event_monitor'
require 'eventbrite/attendee_monitor'
require 'eventbrite/event_summary_generator'
require 'eventbrite/event_summary_uploader'

require 'xero/invoicer'

require 'github/github_monitor'
require 'jenkins/build_status_monitor'
require 'leftronic/dashboard_time'
require 'leftronic/leftronic_publisher'
require 'trello/trello_monitor'
require 'hubot/hubot_monitor'

require 'signup/signup_processor'
require 'signup/partner_enquiry_processor'