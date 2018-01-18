require_relative '../weather_api'

describe DayForecast do
  context 'description based queries' do
    let(:params) { [Date.new.to_s, 0, 0,] }

    describe '#rain?' do
      it 'returns true when rain is mentioned (case insensitive)' do
        expect(DayForecast.new(*params, 'Mixed RaIn and snow').rain?).to be true
      end

      it 'returns true when drizzle is mentioned (case insensitive)' do
        expect(DayForecast.new(*params, 'Freezing dRiZzle').rain?).to be true
      end

      it 'returns false when rain related words are not mentioned' do
        expect(DayForecast.new(*params, 'Snow expected').rain?).to be false
      end
    end

    describe '#thunderstorm?' do
      it 'returns true when thunderstorm is mentioned (case insensitive)' do
        expect(DayForecast.new(*params, 'severe thundErstorms').thunderstorm?).to be true
      end

      it 'returns false when thunderstorm is not mentioned' do
        expect(DayForecast.new(*params, 'Snow expected').thunderstorm?).to be false
      end
    end

    describe '#snow?' do
      it 'returns true when snow is mentioned (case insensitive)' do
        expect(DayForecast.new(*params, 'SnOw flurries').snow?).to be true
      end

      it 'returns false when snow is not mentioned' do
        expect(DayForecast.new(*params, 'Clear').snow?).to be false
      end
    end

    describe '#ice?' do
      it 'returns true when ice is mentioned (case insensitive)' do
        expect(DayForecast.new(*params, 'Ice expected').ice?).to be true
      end

      it 'returns true when icy is mentioned (case insensitive)' do
        expect(DayForecast.new(*params, 'Icy conditions').ice?).to be true
      end

      it 'returns false when ice/icy is not mentioned' do
        expect(DayForecast.new(*params, 'Clear').snow?).to be false
      end
    end
  end

  context 'temperature based' do
    describe '#high_heat?' do
      it 'returns true if high greater than 85' do
        expect(DayForecast.new(Date.new.to_s, 86, 0, '').high_heat?).to be true
      end

      it 'returns false if high is 85' do
        expect(DayForecast.new(Date.new.to_s, 85, 0, '').high_heat?).to be false
      end

      it 'returns false if high is less than 85' do
        expect(DayForecast.new(Date.new.to_s, 3, 0, '').high_heat?).to be false
      end
    end

    describe '#freezing_temp?' do
      it 'returns true if low lower than 32' do
        expect(DayForecast.new(Date.new.to_s, 86, 31, '').freezing_temp?).to be true
      end

      it 'returns false if low is 32' do
        expect(DayForecast.new(Date.new.to_s, 85, 32, '').freezing_temp?).to be false
      end

      it 'returns false if low is greater than 32' do
        expect(DayForecast.new(Date.new.to_s, 3, 35, '').freezing_temp?).to be false
      end
    end
  end
end

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
