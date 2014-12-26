require 'spec_helper'

describe Github::OrganisationMonitor, :vcr do

  before :each do
    Timecop.freeze
    @time = Time.now
  end

  it "should store right value in metrics API" do
    metrics_api_should_receive("github-repository-count", @time, 179)
    # when this happens:
    Github::OrganisationMonitor.perform
  end

  after :each do
    Timecop.return
  end

end
