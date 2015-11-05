require 'spec_helper'

describe PressMetrics do

  before :each do
    Timecop.freeze(Date.new(2014, 2, 4))
  end

  it "should store right values in metrics API" do
    # Which methods are called?
    PressMetrics.should_receive(:sentiment).once
    PressMetrics.should_receive(:spokespeople).once
    PressMetrics.should_receive(:sector_spread).once
    PressMetrics.should_receive(:geographical_spread).once
    PressMetrics.should_receive(:totals).once
    # How many metrics are stored?
    PressMetrics.should_receive(:store_metric).exactly(5).times
    # Do it
    PressMetrics.perform
  end

  it "should show the correct sentiment values", :vcr do
    PressMetrics.sentiment.should == {
      "positive" => 606,
      "neutral" => 8,
      "balanced" => 36,
      "negative" => 1
    }
  end

  it "should show the correct spokespeople", :vcr do
    PressMetrics.spokespeople.should == {
    "Gavin Starks" => 39,
    "Jeni Tennison" => 35,
    "Nigel Shadbolt" => 34,
    "Tim Berners-Lee" => 34,
    "Richard Stirling" => 6,
    "Tom Heath" => 3,
    "Waldo Jaquith" => 3,
    "Liz Carolan" => 3,
    "Ellen Broad" => 3,
    "Ben Cave" => 2,
    "Tom Forth" => 2,
    "Ulrich Atz" => 2,
    "Unnamed ODI spokesperson" => 1,
    "Thomas Forth" => 1,
    "Paul Connell (ODI Leeds)" => 1,
    "James Smith" => 1,
    "Emma Truswell" => 1,
    "" => 1,
    "Hannah Redler" => 1
    }
  end

  it "should show the correct sector spread", :vcr do
    PressMetrics.sector_spread.should == {
     "Technology" => 648,
     "Government" => 263,
     "Corporate" => 193,
     "Cultural" => 50,
     "Financial" => 17,
     "Legal" => 11,
     "Retail" => 10
    } 
  end

  it "should show the correct geographical spread", :vcr do
    PressMetrics.geographical_spread.should == {
    "UK" => 428,
    "Unspecified" => 88,
    "USA" => 45,
    "France" => 20,
    "Europe" => 18,
    "Italy" => 16,
    "Netherlands" => 16,
    "Spain" => 13,
    "Germany" => 12,
    "Malaysia" => 6,
    "India" => 5,
    "Brazil" => 5,
    "Australia" => 5,
    "Ireland" => 4,
    "Pakistan" => 4,
    "Singapore" => 3,
    "New Zealand" => 3,
    "Canada" => 3,
    "Belgium" => 2,
    "Africa" => 2,
    "Mexico" => 2,
    "Kenya" => 1,
    "Hungary" => 1,
    "Ghana" => 1,
    "Argentina" => 1,
    "Asia" => 1,
    "Bangladesh" => 1,
    "Burma" => 1,
    "Peru" => 1,
    "Nigeria" => 1,
    "South Africa" => 1,
    "Switzerland" => 1,
    "Senegal" => 1,
    "Venezuela" => 1,
    "Uruguay" => 1,
    "Tunisia" => 1
    }
  end

  it "should show correct pr totals", :vcr do
    PressMetrics.totals.should == {
      "ODI" => {
        "volume" => 495,
        "value" => 2224369,
        "reach" => 91095755,
      },
      "OpenData" => {
        "volume" => 220,
        "value" => 735522,
        "reach" => 39754858,
      }
    }
  end

  after :each do
    Timecop.return
    PressMetrics.clear_cache!
  end

end
