require 'uri'
require 'net/http'
require 'json'

class WeatherAPI
  def self.validate_forecast_location(location)
    raise ArgumentError.new('Location cannot be blank') if location.nil? || location == ''
  end

  def self.get_forecast(location)
    validate_forecast_location(location)

    uri = build_forecast_uri(location)
    response = Net::HTTP::get_response(uri)
    raise "External API failed with #{response.code}" if !response.is_a?(Net::HTTPSuccess)
    parse_forecast_json(response.body)
  end
end

class YahooWeatherAPI < WeatherAPI
  API_BASE_URL = 'https://query.yahooapis.com/v1/public/yql'
  API_FORECAST_YQL = 'select * from weather.forecast where woeid in (select woeid from geo.places(1) where text="%s")'
  API_FORECAST_PARAMS = [['format', 'json'], ['env', 'store://datatables.org/alltableswithkeys']]

  def self.build_forecast_uri(location)
    uri = URI::parse(API_BASE_URL)
    uri.query = URI.encode_www_form(API_FORECAST_PARAMS + [['q', API_FORECAST_YQL % location]])
    uri
  end

  def self.parse_forecast_json(json_string)
    query = JSON.parse(json_string)['query']
    return [] if query['count'] == 0
    channels = query['results']['channel'].is_a?(Array) ? query['results']['channel'] : [query['results']['channel']]

    # Record location, units & forecast (10 day)
    channels.map{ |c| { location: c['location'], units: c['units'],
                        forecast: c['item']['forecast'] } }
  end
end
