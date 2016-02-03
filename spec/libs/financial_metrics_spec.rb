require 'spec_helper'

describe FinancialMetrics do

  before :each do
    Timecop.freeze(Date.new(2015, 2, 4))
  end

  it "should store right values in metrics API" do
    # Which methods are called?
    FinancialMetrics.should_receive(:cash_reserves).with(2015).once
    FinancialMetrics.should_receive(:value).with(2015).once
    FinancialMetrics.should_receive(:value).with(nil).once
    FinancialMetrics.should_receive(:income).with(2015, 2).once
    FinancialMetrics.should_receive(:income).with(nil, nil).once
    FinancialMetrics.should_receive(:bookings).with(nil, nil).once
    FinancialMetrics.should_receive(:grant_funding).with(2015, 2).once
    FinancialMetrics.should_receive(:bookings).with(2015, 2).once
    FinancialMetrics.should_receive(:bookings_by_sector).with(2015, 2).once
    FinancialMetrics.should_receive(:headcount).with(2015, 2).once
    FinancialMetrics.should_receive(:burn_rate).with(2015, 2).once
    FinancialMetrics.should_receive(:ebitda).with(2015, 2).once
    FinancialMetrics.should_receive(:total_costs).with(2015, 2).once
    # How many metrics are stored?
    FinancialMetrics.should_receive(:store_metric).exactly(13).times
    # Do it
    FinancialMetrics.perform
  end

  it "should show the correct unlocked value", :vcr do
    FinancialMetrics.value(2015).should == 499511
    FinancialMetrics.value.should == 16254195
  end

  it "should show total grant funding", :vcr do
    FinancialMetrics.grant_funding(2015, 2).should == {
      actual:        379000.0,
      annual_target: 3545000.0,
      ytd_target:    558000.0,
    }
  end

  it "should show income", :vcr do
    FinancialMetrics.income(2015, 2).should == {
      actual:        340000.0,
      annual_target: 2862000.0,
      ytd_target:    458000.0,
    }
  end

  it "should show cumulative income", :vcr do
    FinancialMetrics.income(nil, nil).should == 2672123
  end

  it "should show cash reserves", :vcr do
    FinancialMetrics.cash_reserves(2015).should == 1272809.69
  end

  it "should show correct cumulative bookings", :vcr do
    FinancialMetrics.bookings(nil, nil).should == 1925000
  end

  it "should show correct bookings for 2015", :vcr do
    FinancialMetrics.bookings(2015, 2).should == {
      :actual => 158000,
      :annual_target => 1044000,
      :ytd_target => 83000,
    }
  end

  it "should show the correct bookings by sector for 2015", :vcr do
    FinancialMetrics.bookings_by_sector(2015, 2).should == {
      network: {
        actual: 152000.0,
        annual_target: 1252000.0,
        ytd_target: 159000.0
      },
      innovation: {
        actual: 189000.0,
        annual_target: 1419000.0,
        ytd_target: 299000.0
      },
      core: {
        actual: 0.0,
        annual_target: 191000.0,
        ytd_target: 0.0
      }
    }
  end

  it "should show headcount", :vcr do
    FinancialMetrics.headcount(2015, 2).should == {
        actual:        56.0,
        annual_target: 80.0,
        ytd_target:    80.0,
    }
  end

  it "should show burn", :vcr do
    FinancialMetrics.burn_rate(2015, 2).should == 330000.0
    FinancialMetrics.burn_rate(2015, 5).should == 389333.3333333333
    FinancialMetrics.burn_rate(2015, 6).should == 419000.0
  end

  it "should load EBITDA information", :vcr do
    FinancialMetrics.ebitda(2015, 6).should == {
      actual:        -1220000.0,
      latest:        -250000.0,
      annual_target: -3488000.0,
      ytd_target:    -1713000.0,
    }
  end

  it "should load total cost information", :vcr do
    FinancialMetrics.total_costs(2015, 2).should == {
      :actual => 659000.0,
      :annual_target => 6252000.0,
      :ytd_target => 899000.0,
      :breakdown => {
        :network => {
          :actual => 81000.0,
          :annual_target => 1195000.0,
          :ytd_target => 139000.0,
        },
        :innovation => {
          :actual => 173000.0,
          :annual_target => 1891000.0,
          :ytd_target => 297000.0,
        },
        :core => {
          :actual => 80000.0,
          :annual_target => 936000.0,
          :ytd_target => 125000.0,
        },
        :staff => {
          :actual => 201000.0,
          :annual_target => 1230000.0,
          :ytd_target => 194000.0,
        },
        :other => {
          :actual => 124000.0,
          :annual_target => 1000000.0,
          :ytd_target => 144000.0,
        }
      }
    }
  end

  after :each do
    Timecop.return
    FinancialMetrics.clear_cache!
  end

  it "should handle unknown years for entire metrics grab" do
    Timecop.freeze(3001,1,1)
    FinancialMetrics.should_receive(:store_metric).exactly(13).times
    FinancialMetrics.perform
  end


end
