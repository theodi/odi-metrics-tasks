module CapsuleHelper

  def field(org, tag, field)
    org.custom_fields.find{|x| x.label == field && x.tag == tag}
  end

  def opportunity_closed?(opportunity)
    ["Invoiced", "Lost", "No project", "Contract Signed"].include?(opportunity.milestone)
  end

  def coverage_sectors
    [
      "Charity, Not-for-Profit",
      "Data & Information Services",
      "Education",
      "Finance",
      "FMCG",
      "Healthcare",
      "Professional Services",
      "Technology, Media, Telecommunications",
      "Transport, Construction, Engineering",
      "Utilities, Oil & Gas",
    ]
  end

end
