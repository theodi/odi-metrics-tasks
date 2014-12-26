require 'spec_helper'

describe Github::WatchersForksMonitor, :vcr do

  before :each do
    Timecop.freeze
    @time = Time.now
  end

  it "should store right value in metrics API" do
    metrics_api_should_receive("github-watchers", @time, 409)
    metrics_api_should_receive("github-forks", @time, 194)
    # when this happens:
    Github::WatchersForksMonitor.perform
  end

  after :each do
    Timecop.return
  end

end
