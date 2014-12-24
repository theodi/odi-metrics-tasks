When(/^the opportunity age monitor job runs$/) do
  OpportunityAgeMonitor.perform
end

When(/^the pipeline job runs$/) do
  PipelineMetrics.perform
end