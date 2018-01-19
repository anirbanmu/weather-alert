# weather-alert
A small utility written in Ruby that queries the Yahoo Weather API for a 10 day forecast & displays alerts if there are events of note in the upcoming forecast (things like snow, rain, high temps).

### How to run
- Install Ruby (tested with ruby2.3.3 - currently on Ubuntu 17.10)
- Install bundler - `gem install bundler`
- Clone the repo.
- `cd` to inside cloned repo.
- Install required gems - `bundle install`
- Run the commandline utility via `./run.rb <LOCATION SEARCH TERM>` or `ruby run.rb <LOCATION SEARCH TERM>`

### How to run tests
- This assumes the the above instructions on how to run are complete.
- Run `bundle exec rspec` from the repo directory.

### Gems used
- RSpec
- VCR (for recording & playing back network requests to the Yahoo API). This enables running the test even when the network is down.
- Webmock (used by VCR)
