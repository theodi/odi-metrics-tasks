require 'spec_helper'

describe QuarterlyProgress do
  it "should show correct progress for each quarter in 2013", :vcr do
    progress = QuarterlyProgress.progress(2013)

    progress[:q1].should == 97
    progress[:q2].should == 90.2
    progress[:q3].should == 93.4
    progress[:q4].should == 90.8
  end

  it "should show correct progress for each quarter in 2014", :vcr do
    progress = QuarterlyProgress.progress(2014)

    progress[:q1].should == 91.8
    progress[:q2].should == 91.5
    progress[:q3].should == 84.1
    progress[:q4].should == 92.5
  end

  it "should show correct progress for each quarter in 2015", :vcr do
    progress = QuarterlyProgress.progress(2015)

    progress[:q1].should == 82.6
    progress[:q2].should == 82.1
    progress[:q3].should == 72.4
    progress[:q4].should == 0
  end

  it "should store right values in metrics API", :vcr do
    Timecop.freeze
    time = DateTime.now

    h    = {
        '2013' => {
            :q1 => 97.0,
            :q2 => 90.2,
            :q3 => 93.4,
            :q4 => 90.8
        },
        '2014' => {
            :q1 => 91.8,
            :q2 => 91.5,
            :q3 => 84.1,
            :q4 => 92.5
        },
        '2015' => {
            :q1 => 82.6,
            :q2 => 82.1,
            :q3 => 72.4,
            :q4 => 0
        }
    }
    metrics_api_should_receive("quarterly-progress", time, h.to_json)

    QuarterlyProgress.perform
    Timecop.return
  end
end
