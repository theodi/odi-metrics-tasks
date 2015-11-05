require 'spec_helper'

describe Github::PullRequestMonitor, :vcr do

  before :each do
    Timecop.freeze
    @time = Time.now
  end

  it "should store right value in metrics API" do
    metrics_api_should_receive("github-open-pull-requests", @time, 99)
    # when this happens:
    Github::PullRequestMonitor.perform
  end

  after :each do
    Timecop.return
  end

end
