ENV['BC_AUTH_SERVICE'] = 'https://example.com'

require 'simplecov'
SimpleCov.start
require 'rspec'
require 'rack/test'
require 'webmock/rspec'
require 'omniauth'
require 'omniauth-bigcommerce'

RSpec.configure do |config|
  config.include WebMock::API
  config.include Rack::Test::Methods
  config.extend  OmniAuth::Test::StrategyMacros, :type => :strategy
  config.color = true
  config.order = :random
  Kernel.srand config.seed
end

