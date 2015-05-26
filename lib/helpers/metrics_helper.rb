require "httparty"

module MetricsHelper

  def store_metric(name, datetime, data)

    url = "#{ENV['METRICS_API_BASE_URL']}metrics/#{name}"

    json = {
      name: name,
      time: datetime.xmlschema,
      value: data
    }.to_json

    auth = {:username => ENV['METRICS_API_USERNAME'], :password => ENV['METRICS_API_PASSWORD']}

    HTTParty.post(url, :body => json, :headers => { 'Content-Type' => 'application/json' }, :basic_auth => auth )

  end

  def integize(cell)
    if cell.class == String
      cell.gsub(/[^\d\.\-]/, '').to_i
    else
      cell.to_i
    end
  end

end
