require 'spec_helper'

describe DiversityMetrics do

  it "should store right values in metrics API" do
    # Which methods are called?
    DiversityMetrics.should_receive(:gender).once
    # How many metrics are stored?
    DiversityMetrics.should_receive(:store_metric).exactly(1).times
    # Do it
    DiversityMetrics.perform
  end

  it "should show current diversity values", :vcr do
    DiversityMetrics.gender.should == {
      "total" => {
        "male" => 24,
        "female" => 37
      },
      "teams" => {
        "board" => {
          "male" => 6,
          "female" => 2,
        },
        "spt" => {
          "male" => 2,
          "female" => 2,
        },
        "global_network" => {
          "male" => 6,
          "female" => 8,
        },
        "core" => {
          "male" => 5,
          "female" => 20,
        },
        "innovation_unit" => {
          "male" => 11,
          "female" => 9,
        },
        "leadership" => {
          "male" => 5,
          "female" => 7,
        }
      }
    }
  end

end
