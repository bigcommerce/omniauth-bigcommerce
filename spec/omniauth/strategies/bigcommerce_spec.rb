# frozen_string_literal: true

require 'spec_helper'

RSpec.describe OmniAuth::Strategies::BigCommerce do
  subject { described_class.new({}) }

  let(:store_hash) { 'abcdefg' }
  let(:context) { "stores/#{store_hash}" }
  let(:scope) { 'store_v2_products' }
  let(:account_uuid) { 'foobar' }
  let(:request) do
    instance_double(Rack::Request, params: { 'context' => context, 'scope' => scope, 'account_uuid' => account_uuid },
                                   cookies: {}, env: {})
  end

  before do
    OmniAuth.config.test_mode = true
    allow(subject).to receive_messages(request: request, script_name: '')
  end

  after { OmniAuth.config.test_mode = false }

  describe 'options' do
    it 'has correct name' do
      expect(subject.options.name).to eq('bigcommerce')
    end

    describe 'client options' do
      it 'has correct site' do
        # env variable set in spec_helper.rb
        # TODO: change this once we have bigcommerceapp.com url
        expect(subject.options.client_options.site).to eq('https://example.com')
      end

      it 'has correct authorize url' do
        expect(subject.options.client_options.authorize_url).to eq('oauth2/authorize')
      end

      it 'has correct token url' do
        expect(subject.options.client_options.token_url).to eq('oauth2/token')
      end
    end

    describe 'OAuth2 settings' do
      it 'ignores state' do
        expect(subject.options.provider_ignores_state).to be true
      end
    end
  end

  describe 'callback url' do
    it 'has the correct path' do
      expect(subject.callback_path).to eq('/auth/bigcommerce/callback')
    end

    context 'when callback url has a query string' do
      let(:host) { 'https://example.com' }
      let(:query_string) { 'foo=bar' }

      before do
        allow(subject).to receive_messages(full_host: host, script_name: '', query_string: query_string)
      end

      it 'query string is not included in the callback url' do
        expect(subject.callback_url).to eq("#{host}#{subject.callback_path}")
        expect(subject.callback_url).not_to include(query_string)
      end
    end
  end

  describe 'extra params for authorize and token exchange' do
    it 'sets the context and scope parameters in the authorize request' do
      expect(subject.authorize_params['context']).to eq(context)
      expect(subject.authorize_params['scope']).to eq(scope)
    end

    it 'sets the context and scope parameters in the token request' do
      expect(subject.token_params['context']).to eq(context)
      expect(subject.token_params['scope']).to eq(scope)
      expect(subject.token_params['account_uuid']).to eq(account_uuid)
    end
  end
end
