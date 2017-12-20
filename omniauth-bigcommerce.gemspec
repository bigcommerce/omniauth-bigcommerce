# Copyright (c) 2017-present, BigCommerce Pty. Ltd. All rights reserved
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
# documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
# rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit
# persons to whom the Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
# Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
# WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
# OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
require File.expand_path('../lib/omniauth/bigcommerce/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['BigCommerce Engineering']
  gem.email         = ['developer@bigcommerce.com']
  gem.description   = 'Official OmniAuth strategy for BigCommerce.'
  gem.summary       = gem.description
  gem.homepage      = 'https://github.com/bigcommerce/omniauth-bigcommerce'

  gem.files         = Dir['README.md', 'lib/**/*', 'omniauth-bigcommerce.gemspec', 'Gemfile']
  gem.name          = 'omniauth-bigcommerce'
  gem.require_paths = ['lib']
  gem.required_ruby_version = '>= 2.1'
  gem.version       = OmniAuth::BigCommerce::VERSION
  gem.license       = 'MIT'

  gem.add_dependency 'oauth2', '~> 1.3.1'
  gem.add_dependency 'omniauth'
  gem.add_dependency 'omniauth-oauth2', '>= 1.5'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'simplecov'
end
