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
        "male" => 27,
        "female" => 36
      },
      "teams" => {
        "board" => {
          "male" => 6,
          "female" => 2,
        },
        "smt" => {
          "male" => 2,
          "female" => 2,
        },
        "commercial" => {
          "male" => 8,
          "female" => 11,
        },
        "international" => {
          "male" => 3,
          "female" => 6,
        },
        "operations" => {
          "male" => 1,
          "female" => 11,
        },
        "technical" => {
          "male" => 7,
          "female" => 4,
        },
        "leadership" => {
          "male" => 5,
          "female" => 7,
        }
      }
    }
  end

end
