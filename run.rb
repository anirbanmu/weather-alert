#!/usr/bin/env ruby

require_relative 'weather_alert'

forecast = YahooWeatherAPI::get_forecast ARGV[0]
puts "No results found for '#{ARGV[0]}'" and return if forecast.empty?
weather_alert forecast
