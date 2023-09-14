# frozen_string_literal: true

ENV['BC_AUTH_SERVICE'] = 'https://example.com'

require 'simplecov'
SimpleCov.start

require 'omniauth-bigcommerce'

RSpec.configure do |config|
  config.color = true
  config.order = :random
  Kernel.srand config.seed
end
