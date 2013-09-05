require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Bigcommerce < OmniAuth::Strategies::OAuth2
      option :name, "bigcommerce"

      option :provider_ignores_state, true

      option :scope, "NullScope" # Default to empty scope.

      # This is where you pass the options you would pass when
      # initializing your consumer from the OAuth gem.
      option :client_options,
      {
        site: ENV['BC_AUTH_SERVICE'],
        authorize_url: '/oauth2/authorize',
        token_url: '/oauth2/token'
        # TODO: Replace with final service at bigcommerceapp.com
      }

      # These are called after authentication has succeeded. If
      # possible, you should try to set the UID without making
      # additional calls (if the user id is returned with the token
      # or as a URI parameter). This may not be possible with all
      # providers.
      uid{ access_token.params['user']['id'] }

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
        }
      end

      def raw_info
        @raw_info ||= access_token.params
      end

    end
  end
end

OmniAuth.config.add_camelization 'bigcommerce', 'Bigcommerce'
