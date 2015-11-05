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
    # FinancialMetrics.should_receive(:kpis).with(2015).once
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
    FinancialMetrics.value(2013).should == 15210243
    FinancialMetrics.value(2014).should == 544441
    FinancialMetrics.value(2015).should == 6985369
    FinancialMetrics.value.should == 22740053
  end

  it "should show the correct kpi percentage", :vcr do
    FinancialMetrics.kpis(2013).should == 100.0
    FinancialMetrics.kpis(2014).should == 38.0
  end

  it "should show total grant funding", :vcr do
    FinancialMetrics.grant_funding(2014, 2).should == {
      actual:        330000.0,
      annual_target: 3355000.0,
      ytd_target:    374000.0,
    }

    FinancialMetrics.grant_funding(2015, 2).should == {
      actual:        379000.0,
      annual_target: 3545000.0,
      ytd_target:    558000.0,
    }
  end

  it "should show income", :vcr do
    FinancialMetrics.income(2014, 2).should == {
      actual:        302000.0,
      annual_target: 2935000.0,
      ytd_target:    173000.0,
    }

    FinancialMetrics.income(2015, 2).should == {
      actual:        340000.0,
      annual_target: 2862000.0,
      ytd_target:    458000.0,
    }
  end

  it "should show cumulative income", :vcr do
    FinancialMetrics.income(nil, nil).should == 2610123.0
  end

  it "should show cash reserves", :vcr do
    FinancialMetrics.cash_reserves(2014).should == 1086562.0
    FinancialMetrics.cash_reserves(2015).should == 693559.53
  end

  it "should show correct cumulative bookings", :vcr do
    FinancialMetrics.bookings(nil, nil).should == 1823000
  end

  it "should show correct bookings for 2014", :vcr do
    FinancialMetrics.bookings(2014, 2).should == 209000
  end

  it "should show correct bookings for 2015", :vcr do
    FinancialMetrics.bookings(2015, 2).should == {
      :actual => 158000,
      :annual_target => 1044000,
      :ytd_target => 83000,
    }
  end

  it "should show the correct bookings by sector for 2014", :vcr do
    FinancialMetrics.bookings_by_sector(2014, 2).should == {
      research: {
        commercial:     {
          actual:        26000.0,
          annual_target: 1500000.0,
          ytd_target:    0.0,
        },
        non_commercial: {
          actual:        77000.0,
          annual_target: 750000.0,
          ytd_target:    0.0,
        }
      },
      training: {
        commercial:     {
          actual:        13000.0,
          annual_target: 128000.0,
          ytd_target:    17000.0,
        },
        non_commercial: {
          actual:        133000.0,
          annual_target: 181000.0,
          ytd_target:    14000.0,
        }
      },
      projects: {
        commercial:     {
          actual:        1175000.0,
          annual_target: 450000.0,
          ytd_target:    0.0,
        },
        non_commercial: {
          actual:        1039000.0,
          annual_target: 500000.0,
          ytd_target:    50000.0,
        }
      },
      network:  {
        commercial:     {
          actual:        245000.0,
          annual_target: 874000.0,
          ytd_target:    142000.0,
        },
        non_commercial: {
          actual:        39000.0,
          annual_target: 45000.0,
          ytd_target:    25000.0,
        }
      }
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
    FinancialMetrics.headcount(2014, 2).should == {
        actual:        22.0,
        annual_target: 34.0,
        ytd_target:    26.0,
    }

    FinancialMetrics.headcount(2015, 2).should == {
        actual:        47.0,
        annual_target: 64.0,
        ytd_target:    64.0,
    }
  end

  it "should show burn", :vcr do
    FinancialMetrics.burn_rate(2014, 2).should == 207000.0
    FinancialMetrics.burn_rate(2014, 5).should == 265000.0
    FinancialMetrics.burn_rate(2014, 6).should == 265000.0

    FinancialMetrics.burn_rate(2015, 2).should == 330000.0
    FinancialMetrics.burn_rate(2015, 5).should == 389333.3333333333
    FinancialMetrics.burn_rate(2015, 6).should == 419000.0
  end

  it "should load EBITDA information", :vcr do
    FinancialMetrics.ebitda(2014, 6).should == {
      actual:        -944000.0,
      latest:        -253000.0,
      annual_target: -3684000.0,
      ytd_target:    -2496000.0,
    }

    FinancialMetrics.ebitda(2015, 6).should == {
      actual:        -1220000.0,
      latest:        -250000.0,
      annual_target: -3488000.0,
      ytd_target:    -1713000.0,
    }
  end

  it "should load total cost information", :vcr do

    FinancialMetrics.total_costs(2014, 2).should == {
      :actual => 1245000.0,
      :annual_target => 6620000.0,
      :ytd_target => 1380000.0,
      :breakdown => {
        :variable => {
          :research => {
            :actual => 6000.0,
            :annual_target => 448000.0,
            :ytd_target => 0.0
          },
          :training => {
            :actual => 8000.0,
            :annual_target => 124000.0,
            :ytd_target => 13000.0
          },
          :projects => {
            :actual => 10000.0,
            :annual_target => 398000.0,
            :ytd_target => 22000.0
          },
          :network => {
            :actual => 12000.0,
            :annual_target => 101000.0,
            :ytd_target => 10000.0
          }
        },
        :fixed => {
          :staff => {
            :actual => 662000.0,
            :annual_target => 2113000.0,
            :ytd_target => 277000.0
          },
          :associates => {
            :actual => 198000.0,
            :annual_target => 858000.0,
            :ytd_target => 112000.0
          },
          :office_and_operational => {
            :actual => 129000.0,
            :annual_target => 494000.0,
            :ytd_target => 82000.0
          },
          :delivery => {
            :actual => 62000.0,
            :annual_target => 778000.0,
            :ytd_target => 82000.0
          },
          :communications => {
            :actual => 85000.0, :annual_target => 315000.0, :ytd_target => 52000.0
          },
          :professional_fees => {
            :actual => 59000.0,
            :annual_target => 200000.0,
            :ytd_target => 34000.0
          },
          :software => {
            :actual => 14000.0, :annual_target => 111000.0, :ytd_target => 16000.0
          }
        }
      }
    }

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

end
