class Hash
  def compact
    delete_if { |k, v| !v }
  end
end

require 'resque'

# Configure CapsuleCRM connection
require 'capsulecrm'
CapsuleCRM.account_name = ENV['CAPSULECRM_ACCOUNT_NAME']
CapsuleCRM.api_token = ENV['CAPSULECRM_API_TOKEN']
CapsuleCRM.initialize!

require 'helpers/metrics_helper'
require 'helpers/membership_helper'
require 'helpers/google_drive_helper'
require 'helpers/product_helper'

require 'github/github_connection'
require 'github/organisation_monitor'
require 'github/issue_monitor'
require 'github/watchers_forks_monitor'
require 'github/pull_request_monitor'
require 'github/outgoing_pull_request_monitor'

require 'gemnasium/dependency_metrics'

require 'trello/trello_board'
require 'trello/trello_boards'
require 'trello/trello_tasks'
require 'trello/quarterly_progress'

require 'hubot/hubot_monitor'

require 'certificates/certificate_count'

require 'capsulecrm/capsule_helper'
require 'capsulecrm/opportunity_age_monitor'
require 'capsulecrm/membership_count'
require 'capsulecrm/membership_coverage'
require 'capsulecrm/membership_renewals'
require 'capsulecrm/pipeline_metrics'

require 'google_drive/financial_metrics'
require 'google_drive/network_metrics'

require 'precisemedia/press_metrics'

require 'diversity/diversity_metrics'

require 'airbrake/application_errors'

def environment
  ENV['RACK_ENV'] || 'production'
end
