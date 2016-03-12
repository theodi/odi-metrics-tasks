class NetworkMetrics

  @queue = :metrics

  extend MetricsHelper
  extend GoogleDriveHelper

  def self.perform
    current_year  = DateTime.now.year
    current_month = DateTime.now.month
    {
      "current-year-reach"                   => reach(current_year, current_month),
      "cumulative-reach"                     => reach(nil, nil),
      # "current-year-pr-pieces"               => pr_pieces(current_year),
      "current-year-flagship-stories"        => flagship_stories(current_year, current_month),
      # "current-year-events-hosted"           => events_hosted(current_year),
      "current-year-people-trained"          => people_trained(current_year, current_month),
      "cumulative-people-trained"            => people_trained(nil, nil),
      "current-year-trainers-trained"        => trainers_trained(current_year, current_month),
      "current-year-network-size"            => network_size(current_year, current_month),
      "cumulative-network-size"              => network_size(nil, nil)
    }.each_pair do |metric, value|
      store_metric metric, DateTime.now, value
    end
    clear_cache!
  end

  def self.reach(year = nil, month = nil)
    total_block = Proc.new { |x| x.class == Hash ? x[:actual] : x }
    if year.nil? && month.nil?
      # Total comes from a single cell
      total = metrics_cell 'People reached', "lifetime", method(:integize)
      # Breakdown is added up
      active = 0
      passive = 0
      years.each do |year|
        reach = reach(year, 12)
        active += reach[:breakdown][:active].is_a?(Hash) ? reach[:breakdown][:active][:actual] : reach[:breakdown][:active]
        passive += reach[:breakdown][:passive].is_a?(Hash) ? reach[:breakdown][:passive][:actual] : reach[:breakdown][:passive]
      end
    else
      active  = extract_metric "Active Reach", year, month, method(:integize)
      passive = extract_metric "Passive Reach", year, month, method(:integize)
      if active.class == Hash && passive.class == Hash
        total = active.inject({}) do |data, (k, v)|
          data[k] = v + passive[k]
          data
        end
      else
        total = (total_block.call(active) || 0) + (total_block.call(passive) || 0) # handle nil data
      end
    end
    {
      total: total,
      breakdown: {
        active:  active || 0,
        passive: passive || 0,
      }
    }
  end

  def self.pr_pieces(year)
    metrics_cell('PR Pieces', year, method(:integize))
  end

  def self.flagship_stories(year, month)
    extract_metric 'Flagship stories', year, month, method(:integize)
  end

  def self.events_hosted(year)
    metrics_cell('Events hosted', year, method(:integize))
  end

  def self.people_trained(year = nil, month = nil)
    if year.nil? && month.nil?
      metrics_cell('People trained', "lifetime", method(:integize))
    else
      h     = {
        commercial:     'Commercial people trained',
        non_commercial: 'Non-commercial people trained',
        nodes:          'People trained by nodes',
        total:          'People trained',
      }

      data = extract_metrics h, year, month, method(:integize)
      unless data.has_key?(:total)
        data[:total] = (data[:commercial].try(:[], :actual)||0) + (data[:non_commercial].try(:[], :actual)||0)
      end
      if data.has_key?(:nodes)
        data[:total][:actual] = data[:total][:actual] + data[:nodes][:actual]
        data.delete(:nodes) # Delete the nodes value
      end
      data
    end
  end

  def self.trainers_trained(year, month)
    extract_metric 'Trainers trained', year, month, method(:integize)
  end

  def self.network_size(year = nil, month = nil)
    if year.nil? && month.nil?
      metrics_cell('Network size', "lifetime", method(:integize))
    else
      h     = {
          partners:   'Partners',
          sponsors:   'Sponsors',
          supporters: 'Supporters',
          startups:   'Startups',
          nodes:      'Nodes',
          affiliates: 'Affiliates',
          members:    'Members',
      }
      extract_metrics h, year, month, method(:integize)
    end
  end

end
