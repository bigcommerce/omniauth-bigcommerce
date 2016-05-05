require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class BigCommerce < OmniAuth::Strategies::OAuth2
      option :name, 'bigcommerce'
      option :provider_ignores_state, true
      option :scope, 'users_basic_information'
      option :authorize_options, [:scope, :context]
      option :token_options, [:scope, :context]
      option :client_options, {
        site: ENV['BC_AUTH_SERVICE'] || 'https://login.bigcommerce.com',
        authorize_url: '/oauth2/authorize',
        token_url: '/oauth2/token'
      }

      uid { access_token.params['user']['id'] }

      info do
        {
          name: access_token.params['user']['username'],
          email: access_token.params['user']['email'],
        }
      end

      credentials do
        {
          token: access_token
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
