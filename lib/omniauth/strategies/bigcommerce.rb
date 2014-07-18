require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Bigcommerce < OmniAuth::Strategies::OAuth2
      option :name, "bigcommerce"

      option :provider_ignores_state, true

      option :scope, "users_basic_information"

      option :client_options,
      {
        site: ENV['BC_AUTH_SERVICE'] || 'https://login.bigcommerce.com',
        authorize_url: '/oauth2/authorize',
        token_url: '/oauth2/token'
      }

      uid { access_token.params['context'] }

      info do
        {
          name: access_token.params['user']['username'],
          email: access_token.params['user']['email'],
        }
      end

      credentials do
        {
          :token => access_token
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

    end
  end
end

OmniAuth.config.add_camelization 'bigcommerce', 'Bigcommerce'
