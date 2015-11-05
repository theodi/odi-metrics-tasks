require 'spec_helper'

describe Github::IssueMonitor, :vcr do

  before :each do
    Timecop.freeze
    @time = Time.now
  end

  it "should store right value in metrics API" do
    metrics_api_should_receive("github-open-issue-count", @time, 651)
    # when this happens:
    Github::IssueMonitor.perform
  end

  after :each do
    Timecop.return
  end

end
