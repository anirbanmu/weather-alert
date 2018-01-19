require_relative 'weather_api'

def location_concat(location)
  "#{location.city}, #{location.region}, #{location.country}"
end

def weather_alert(weather_forecasts)
  alerts = []

  weather_forecasts.each do |w|
    current_alerts = []
    w.forecasts.each do |f|
      alert_template = "%s on #{f.date.strftime('%A, %B %d, %Y')} in #{location_concat(w.location)}"
      current_alerts.push(alert_template % 'Rain') if f.rain?
      current_alerts.push(alert_template % 'Thunderstorms') if f.thunderstorm?
      current_alerts.push(alert_template % 'Snow') if f.snow?
      current_alerts.push(alert_template % 'Ice') if f.ice?
      current_alerts.push(alert_template % "High heat (#{f.high}#{w.temp_unit})") if f.high_heat?
      current_alerts.push(alert_template % "Freezing cold (#{f.low}#{w.temp_unit})") if f.freezing_temp?
    end
    current_alerts.push("No alerts for this location #{location_concat(w.location)}") if current_alerts.empty?
    alerts.push(*current_alerts)
  end

  alerts.each{ |a| puts a }
end
