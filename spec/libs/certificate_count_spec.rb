require 'spec_helper'

describe CertificateCount do
  it "should show the correct number of published Open Data Certificates", :vcr do
    CertificateCount.odcs.should == 151401
  end

  it "should store right values in metrics API", :vcr do
    Timecop.freeze
    time = DateTime.now
    metrics_api_should_receive("certificated-datasets", time, 151401)

    CertificateCount.perform
    Timecop.return
  end
end
