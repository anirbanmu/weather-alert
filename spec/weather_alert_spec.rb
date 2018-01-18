require_relative '../weather_alert'

describe 'weather_alert' do
  let(:location) { double(city: 'City', country: 'Country', region: 'Region') }

  #let(:location) { Object.new(city: 'City', country: 'Country', region: 'Region') }
  let(:day_forecast) { double(date: Date.new, high: 46, low: 45, description: '') }
  let(:weather_forecasts) { [double(location: location, temp_unit: 'F', forecasts: [day_forecast])] }

  let(:expected_alert_items) { [location.city, location.country, location.region,
                                day_forecast.date.strftime('%A'), # Day name
                                day_forecast.date.strftime('%B'), # Month name
                                day_forecast.date.strftime('%d'), # Day of the month
                                day_forecast.date.strftime('%Y'), # Year
                               ] }

  before do
    allow(day_forecast).to receive(:rain?).and_return(false)
    allow(day_forecast).to receive(:thunderstorm?).and_return(false)
    allow(day_forecast).to receive(:snow?).and_return(false)
    allow(day_forecast).to receive(:ice?).and_return(false)
    allow(day_forecast).to receive(:high_heat?).and_return(false)
    allow(day_forecast).to receive(:freezing_temp?).and_return(false)
  end

  it 'prints nothing with calm forecast' do
    expect{ weather_alert(weather_forecasts) }.to_not output.to_stdout
  end

  it 'prints rain message' do
    allow(day_forecast).to receive(:rain?).and_return(true)
    verify_output(expect{ weather_alert(weather_forecasts) }, expected_alert_items + %w[rain])
  end

  it 'prints thunderstorm message' do
    allow(day_forecast).to receive(:thunderstorm?).and_return(true)
    verify_output(expect{ weather_alert(weather_forecasts) }, expected_alert_items + %w[thunderstorm])
  end

  it 'prints snow message' do
    allow(day_forecast).to receive(:snow?).and_return(true)
    verify_output(expect{ weather_alert(weather_forecasts) }, expected_alert_items + %w[snow])
  end

  it 'prints ice message' do
    allow(day_forecast).to receive(:ice?).and_return(true)
    verify_output(expect{ weather_alert(weather_forecasts) }, expected_alert_items + %w[ice])
  end

  it 'prints high temp message' do
    allow(day_forecast).to receive(:high_heat?).and_return(true)
    verify_output(expect{ weather_alert(weather_forecasts) }, expected_alert_items + %w[high heat])
  end

  it 'prints freezing temp message' do
    allow(day_forecast).to receive(:freezing_temp?).and_return(true)
    verify_output(expect{ weather_alert(weather_forecasts) }, expected_alert_items + %w[freezing cold])
  end

  def verify_output(expectation, items)
    items.each do |i|
      expectation.to output(/#{i}/i).to_stdout
    end
  end
end
