require_relative '../weather_api'

describe WeatherAPI do
  describe '.get_forecast' do
    context 'validation' do
      it 'rejects nil location' do
        expect{ WeatherAPI::get_forecast(nil) }.to raise_error(ArgumentError)
      end

      it 'rejects blank location' do
        expect{ WeatherAPI::get_forecast('') }.to raise_error(ArgumentError)
      end
    end

    it 'cannot be used without subclassing' do
      expect{ WeatherAPI::get_forecast('Chicago') }.to raise_error(NoMethodError)
    end
  end
end

describe YahooWeatherAPI, :vcr do
  describe '.get_forecast' do
    it 'returns no results when location is bad' do
      expect(YahooWeatherAPI::get_forecast('_')).to be_empty
    end

    it 'returns one result when a real location is used' do
      expect(YahooWeatherAPI::get_forecast('Minneapolis').length).to eq(1)
    end
  end
end
