# Setup

Given /^there is an existing organisation in CapsuleCRM called "(.*?)"$/ do |organisation_name|
  CapsuleCRM::Organisation.find_all(:q => organisation_name).should be_empty
  @organisation = CapsuleCRM::Organisation.new(:name => organisation_name)
  @organisation.save
  CapsuleCRM::Organisation.find_all(:q => organisation_name).should_not be_empty
  @capsule_cleanup << @organisation
end

# Organisations

Given(/^the following sector tags exist in CapsuleCRM:$/) do |table|
  # This is *impossible* to check. The CapsuleCRM API doesn't support listing available tags, or
  # managing them, only what they are assigned to. We just have to assume that the tags are
  # set up correctly in the UI.
end

Given(/^the following members exist in CapsuleCRM:$/) do |table|
  membership_length = {
    "sponsor"   => 3.years,
    "partner"   => 3.years,
    "member"    => 1.year,
    "supporter" => 1.year
  }
  table.hashes.each do |row|
    joined = (row["renewal_in_x_weeks"].to_f.weeks.from_now - membership_length[row["level"]]).to_date
    steps %{
      Given there is an existing organisation in CapsuleCRM called "#{row["name"]}"
      And the organisation is a member at level "#{row["level"]}"
      And the organisation joined on #{joined}
      And that organisation has a tag called "#{row["sector"]}"
    }
  end
end

Given(/^the following opportunities exist in CapsuleCRM with paid invoices in Xero if closed:$/) do |table|
  table.hashes.each do |row|
    steps %{
      Given there is an existing organisation in CapsuleCRM called "#{row["organisation"]}"
      And there is an opportunity against that organisation
      And that opportunity is in stage "#{row["stage"]}" with likelihood #{row['likelihood']}
      And that opportunity has the value #{row["value"]} per year for #{row['duration']} years
      And that opportunity is expected to close on #{Date.today + row["close_in_x_weeks"].to_i.weeks}
      And that opportunity was opened on #{Date.today - row["opened_x_days_ago"].to_i.days}
    }
    # if row["stage"] == "Closed"
    #   steps %{
    #     Given there is a contact in Xero for "#{row["organisation"]}"
    #     And that contact has a paid invoice in Xero for #{row["value"]} for "membership" on sales code "membership"
    #     And that invoice was raised on #{Date.today - row["opened_x_weeks_ago"].to_i.weeks}
    #     And that invoice has been paid
    #   }
    # end
  end
end

Given(/^the organisation is a member at level "(.*?)"$/) do |level|
  tag = CapsuleCRM::Tag.new(
    @organisation,
    :name => 'Membership'
  )
  tag.save
  custom_field = CapsuleCRM::CustomField.new(
    @organisation,
    {
      tag: 'Membership',
      label: 'Level',
      text: level,
    }
  )
  custom_field.save
end

Given(/^the organisation joined on (#{DATE})$/) do |date|
  custom_field = CapsuleCRM::CustomField.new(
    @organisation,
    {
      tag: 'Membership',
      label: 'Joined',
      date: date,
    }
  )
  custom_field.save
end

# Opportunities

Given(/^there is an opportunity against that organisation$/) do
  # Create opportunity against organisation
  @opportunity = CapsuleCRM::Opportunity.new(
    :party_id            => @organisation.id,
    :name                => "Membership",
    :milestone           => 'Closed',
    :probability         => 100,
  )
  @opportunity.save
end

Given(/^that opportunity is in stage "(.*?)" with likelihood (\d+)%$/) do |milestone, likelihood|
  @opportunity.milestone = milestone
  @opportunity.probability = likelihood.to_i
  @opportunity.save
end

Given(/^that opportunity has the value (\d+) per year for (\d+) years$/) do |value, duration|
  @opportunity.value = value.to_i
  @opportunity.duration = duration.to_i
  @opportunity.duration_basis = 'YEAR'
  @opportunity.save
end

Given(/^that opportunity is expected to close on (#{DATE})$/) do |date|
  @opportunity.expected_close_date = date
  @opportunity.save
  # Mock the actual close date, as it's done by capsule internally
  if date <= Date.today
    $opportunity_closed_dates ||= {}
    $opportunity_closed_dates[@opportunity.id] = date.to_s
    class CapsuleCRM::Opportunity
      def actual_close_date
        $opportunity_closed_dates[id]
      end
    end
  end
end

Given(/^that opportunity was opened on (#{DATE})$/) do |date|
  $opportunity_created_dates ||= {}
  $opportunity_created_dates[@opportunity.id] = date
  # We can't set the actual created date in capsulecrm, so we have to mock it instead.
  # This is AWFUL, but I can't work out how to access the original object ID inside the partial mock.
  # Suggestions accepted!
  class CapsuleCRM::Opportunity
    def created_at
      $opportunity_created_dates[id]
    end
  end
end

# Data tags

Given /^that organisation has a tag called "(.*?)"$/ do |tag_name|
  @tag = CapsuleCRM::Tag.new(
    @organisation,
    :name => tag_name
  )
  @tag.save
end