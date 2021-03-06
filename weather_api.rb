require 'uri'
require 'net/http'
require 'json'
require 'date'

class DayForecast
  attr_reader :date, :high, :low, :description

  def initialize(date, high, low, description)
    @date = Date.parse(date)
    @high = high.to_i
    @low = low.to_i
    @description = description
    @downcased_description = description.strip.downcase
  end

  def rain?
    mentioned? %w[rain drizzle]
  end

  def thunderstorm?
    mentioned? %w[thunderstorm]
  end

  def snow?
    mentioned? %w[snow]
  end

  def ice?
    mentioned? %w[ice icy]
  end

  def high_heat?
    self.high > 85
  end

  def freezing_temp?
    self.low < 32
  end

  private

  def mentioned?(keywords)
    keywords.any?{ |k| @downcased_description.include? k }
  end
end

class Location
  attr_reader :city, :country, :region

  def initialize(city, country, region)
    @city = city.strip
    @country = country.strip
    @region = region.strip
  end
end

class Forecast
  attr_reader :location, :temp_unit, :forecasts

  def initialize(location, temp_unit, day_forecasts)
    @location = location
    raise ArgumentError.new('Temperature unit is expected to be F') if temp_unit.downcase != 'f'
    @temp_unit = temp_unit
    @forecasts = day_forecasts
  end
end

class WeatherAPI
  def self.validate_forecast_location(location)
    raise ArgumentError.new('Location cannot be blank') if location.nil? || location == ''
  end

  def self.get_forecast(location)
    validate_forecast_location(location)

    uri = build_forecast_uri(location)
    response = Net::HTTP::get_response(uri)
    raise "External API failed with #{response.code}" if !response.is_a?(Net::HTTPSuccess)
    parse_forecast_json(JSON.parse(response.body))
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

  def self.parse_forecast_json(json)
    query = json['query']
    return [] if query['count'] == 0
    channels = query['results']['channel'].is_a?(Array) ? query['results']['channel'] : [query['results']['channel']]

    # Record location, units & forecast (10 day)
    channels.map do |c|
      l = c['location']
      Forecast.new(Location.new(l['city'], l['country'], l['region']),
                   c['units']['temperature'],
                   c['item']['forecast'].map{ |f| DayForecast.new(f['date'], f['high'], f['low'], f['text']) })
    end
  end
end
