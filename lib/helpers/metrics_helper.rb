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

  def strip_number(cell)
    if cell.class == String
      cell.gsub(/[^\d\.\-]/, '')
    else
      cell
    end
  end

  def integize(cell)
    strip_number(cell).to_i
  end
  
  def floatize(cell)
    strip_number(cell).to_f
  end

  def years
    2013..Date.today.year
  end
end
