# -*- encoding: utf-8 -*-
require File.expand_path('../lib/omniauth/bigcommerce/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['Tom Allen, Phil Muir, Sasha Gerrand']
  gem.email         = ['developer@bigcommerce.com']
  gem.description   = %q{Official OmniAuth strategy for BigCommerce.}
  gem.summary       = %q{Official OmniAuth strategy for BigCommerce.}
  gem.homepage      = 'https://github.com/bigcommerce/omniauth-bigcommerce'

  gem.files         = Dir['README.md', 'lib/**/*', 'omniauth-bigcommerce.gemspec', 'Gemfile']
  gem.name          = 'omniauth-bigcommerce'
  gem.require_paths = ['lib']
  gem.required_ruby_version = '>= 2.1'
  gem.version       = OmniAuth::BigCommerce::VERSION

  gem.add_dependency 'omniauth'
  gem.add_dependency 'omniauth-oauth2', '>= 1.1.1'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'simplecov'
end
