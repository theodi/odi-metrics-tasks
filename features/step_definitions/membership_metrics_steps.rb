When(/^the membership count job runs$/) do
  MembershipCount.perform
end

When(/^the membership coverage job runs$/) do
  MembershipCoverage.perform
end

When(/^the membership renewals job runs$/) do
  MembershipRenewals.perform
end