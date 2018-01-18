require_relative 'weather_api'

def weather_alert(location)
  weather = YahooWeatherAPI::get_forecast(location)
  puts 'No forecast found for given search location' if weather.empty?

  weather.each do |w|
    w.forecasts.each do |f|
      alert_template = "Expect %s on #{f.date.strftime('%A, %B %d, %Y')} in #{w.location.city}, #{w.location.region}, #{w.location.country}"
      puts alert_template % 'rain' if f.rain?
      puts alert_template % 'thunderstorms' if f.thunderstorm?
      puts alert_template % 'snow' if f.snow?
      puts alert_template % 'ice' if f.ice?
      puts alert_template % "high heat (#{f.high}#{w.temp_unit})" if f.high_heat?
      puts alert_template % "freezing cold (#{f.low}#{w.temp_unit})" if f.freezing_temp?
    end
  end
end

weather_alert ARGV[0]
