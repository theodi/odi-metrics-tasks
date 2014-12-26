require 'spec_helper'

describe Github::OutgoingPullRequestMonitor, :vcr do

  before :each do
    Timecop.freeze
    @time = Time.now
  end

  it "should store right value in metrics API" do
    metrics_api_should_receive("github-outgoing-pull-requests", @time, 2)
    # when this happens:
    Github::OutgoingPullRequestMonitor.perform
  end

  after :each do
    Timecop.return
  end

end
