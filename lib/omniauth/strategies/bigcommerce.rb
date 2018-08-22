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
require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    ##
    # BigCommerce OAuth strategy for OmniAuth
    #
    class BigCommerce < OmniAuth::Strategies::OAuth2
      option :name, 'bigcommerce'
      option :provider_ignores_state, true
      option :scope, 'users_basic_information'
      option :authorize_options, [:scope, :context]
      option :token_options, [:scope, :context]
      option :client_options,
             site: ENV.fetch('BC_AUTH_SERVICE', 'https://login.bigcommerce.com'),
             authorize_url: '/oauth2/authorize',
             token_url: '/oauth2/token'


      uid { access_token.params['user']['id'] }

      info do
        {
          name: access_token.params['user']['username'],
          email: access_token.params['user']['email']
        }
      end

      extra do
        {
          raw_info: raw_info,
          scopes: raw_info['scope'],
          context: raw_info['context']
        }
      end

      def raw_info
        @raw_info ||= access_token.params
      end

      # Exclude query string in callback url. This used to be part of omniauth-oauth2, but was
      # removed in 1.4.0: https://github.com/intridea/omniauth-oauth2/pull/70
      def callback_url
        full_host + script_name + callback_path
      end

      # Make sure to pass scope and context through to the authorize call
      # https://github.com/zquestz/omniauth-google-oauth2/blob/master/lib/omniauth/strategies/google_oauth2.rb#L26
      def authorize_params
        super.tap do |params|
          options[:authorize_options].each do |k|
            params[k] = request.params[k.to_s] unless [nil, ''].include?(request.params[k.to_s])
          end
        end
      end

      # Make sure to pass scope and context through to the token exchange call
      def token_params
        super.tap do |params|
          options[:token_options].each do |k|
            params[k] = request.params[k.to_s] unless [nil, ''].include?(request.params[k.to_s])
          end
        end
      end
    end
  end
end

OmniAuth.config.add_camelization 'bigcommerce', 'BigCommerce'
