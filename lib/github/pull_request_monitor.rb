require 'httparty'
require 'json'

class Github::PullRequestMonitor
  
  @queue = :metrics
  
  extend MetricsHelper
  
  def self.perform
    # Connect
    github = Github.connection
    open_pull_requests = github.search.issues(q: "is:open is:pr user:#{ENV['GITHUB_ORGANISATION']}").total_count
    # Push into metrics
    store_metric "github-open-pull-requests", DateTime.now, open_pull_requests
  rescue Faraday::Error::TimeoutError, Faraday::Error::ConnectionFailed
    # We sometimes get oauth timeouts on these requests. Let's just absorb them quietly and wait for the next time round.
    nil
  rescue Github::Error::InternalServerError, Github::Error::ServiceError
    # Sometimes Github gives us server errors too. Let's ignore those as well.
    nil
  end
  
end