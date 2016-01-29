require 'google_drive'
require 'google_drive/auth'
require 'yaml'

module GoogleDriveHelper
  @@lookups = YAML.load(File.open(File.join(File.dirname(__FILE__), '..', '..', 'config/lookups.yaml')))

  def extract_metrics h, year, month, block
    Hash[
      h.select do |key, value|
        cell_location(year, value)
      end.map do |key, value|
        [key, extract_metric(value, year, month, block)]
      end
    ]
  end

  def extract_metric name, year, month, block
    location = cell_location year, name
    return nil if location.nil? # check we have a valid ref
    if location.has_key? "cell_ref"
      metrics_cell name, year, block
    else
      metric_with_target name, year, month, block
    end
  end

  def metric_with_target name, year, month, block
    location             = cell_location(year, name)
    return nil if location.nil? # check we have a valid ref
    location['document'] ||= @@lookups['document_keys'][environment]['default']
    ytd_method = location['ytd_method'] || @@lookups['default_ytd_method']
    ytd_aggregator = case ytd_method
    when "sum"
      Proc.new { |x| x.inject(0.0){|sum,val| sum + floatize(val) }}
    when "latest"
      Proc.new { |x| floatize([x].flatten.last) }
    end
    multiplier = location['multiplier'] || @@lookups['default_multiplier']
    data = {}
    data[:actual] = (block.call(
            metrics_worksheet(location['document'], location['sheet'])[location['actual']]
          ) * multiplier) if location['actual']
    data[:latest] = (block.call(
            metrics_worksheet(location['document'], location['sheet'])[location['latest']].slice(0,month).select{|x| x.to_f != 0.0}.last
          ) * multiplier) if location['latest']
    data[:annual_target] = (block.call(
            metrics_worksheet(location['document'], location['sheet'])[location['annual_target']]
          ) * multiplier) if location['annual_target']
    data[:ytd_target] = (block.call(
            ytd_aggregator.call(
              metrics_worksheet(location['document'], location['sheet'])[location['ytd_target']].slice(0,month)
            )
          ) * multiplier) if location['ytd_target']
    data
  end

  def google_drive
    @@google_drive ||= GoogleDriveAuth.new.session
  end

  def metrics_spreadsheet(doc_name)
    key                         = @@lookups['document_keys'][environment][doc_name]
    @@metrics_spreadsheets      ||= {}
    @@metrics_spreadsheets[key] ||= google_drive.spreadsheet_by_key(key)
  end

  def metrics_worksheet doc_name, worksheet_name
    @@metrics_worksheets ||= {}
    key = @@lookups['document_keys'][environment][doc_name]
    @@metrics_worksheets["#{key} #{worksheet_name}"] ||= metrics_spreadsheet(doc_name).worksheet_by_title worksheet_name.to_s
  end

  def cell_location year, identifier
    year = Date.today.year if year.nil?
    @@lookups['cell_lookups'][year][identifier] rescue nil
  end

  def metrics_total name, year, block
    location = cell_location(year, name)
    return nil if location.nil? # check we have a valid ref
    ref = location.has_key?("actual") ? "actual" : "cell_ref"
    metrics_cell name, year, block, ref
  end

  def metrics_cell identifier, year, block, ref = "cell_ref"
    location             = cell_location(year, identifier)
    return nil if location.nil? # check we have a valid ref
    location['document'] ||= @@lookups['document_keys'][environment]['default']
    multiplier = location['multiplier'] || @@lookups['default_multiplier']

    attempt = 1
    begin
      block.call(metrics_worksheet(location["document"], location["sheet"])[location[ref]]) * multiplier
    rescue GoogleDrive::ResponseCodeError
      attempt += 1
      if attempt < 5
        # clear_cache!
        retry
      else
        raise
      end
    end
  end

  def clear_cache!
    @@metrics_spreadsheets = {}
    @@metrics_worksheets = {}
  end
end
