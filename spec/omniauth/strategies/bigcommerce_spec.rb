# frozen_string_literal: true

require 'spec_helper'
require 'faraday'

RSpec.describe OmniAuth::Strategies::BigCommerce do
  let(:store_hash) { 'abcdefg' }
  let(:context) { "stores/#{store_hash}" }
  let(:scope) { 'store_v2_products' }
  let(:account_uuid) { 'foobar' }
  let(:request) do
    double('Request', params: { 'context' => context, 'scope' => scope, 'account_uuid' => account_uuid }, cookies: {},
                      env: {})
  end

  before do
    OmniAuth.config.test_mode = true
    allow(subject).to receive(:request).and_return(request)
    allow(subject).to receive(:script_name).and_return('')
  end
  after { OmniAuth.config.test_mode = false }
  subject { OmniAuth::Strategies::BigCommerce.new({}) }

  describe 'options' do
    it 'should have correct name' do
      expect(subject.options.name).to eq('bigcommerce')
    end

    describe 'client options' do
      it 'should have correct site' do
        # env variable set in spec_helper.rb
        # TODO: change this once we have bigcommerceapp.com url
        expect(subject.options.client_options.site).to eq('https://example.com')
      end

      it 'should have correct authorize url' do
        expect(subject.options.client_options.authorize_url).to eq('/oauth2/authorize')
      end

      it 'should have correct token url' do
        expect(subject.options.client_options.token_url).to eq('/oauth2/token')
      end

      it 'should send client credentials in the request body' do
        # oauth2 2.x defaults to :basic_auth; BigCommerce expects credentials in the body
        expect(subject.options.client_options.auth_scheme).to eq(:request_body)
      end
    end

    describe 'OAuth2 settings' do
      it 'should ignore state' do
        expect(subject.options.provider_ignores_state).to eq true
      end
    end
  end

  describe 'callback url' do
    it 'should have the correct path' do
      expect(subject.callback_path).to eq('/auth/bigcommerce/callback')
    end

    context 'when callback url has a query string' do
      let(:host) { 'https://example.com' }
      let(:query_string) { 'foo=bar' }
      before do
        allow(subject).to receive(:full_host).and_return(host)
        allow(subject).to receive(:query_string).and_return(query_string)
      end

      it 'query string should not be included in the callback url' do
        expect(subject.callback_url).to eq("#{host}#{subject.callback_path}")
        expect(subject.callback_url).to_not include(query_string)
      end
    end
  end

  describe 'extra params for authorize and token exchange' do
    it 'should set the context and scope parameters in the authorize request' do
      expect(subject.authorize_params['context']).to eq(context)
      expect(subject.authorize_params['scope']).to eq(scope)
    end

    it 'should set the context and scope parameters in the token request' do
      expect(subject.token_params['context']).to eq(context)
      expect(subject.token_params['scope']).to eq(scope)
      expect(subject.token_params['account_uuid']).to eq(account_uuid)
    end
  end

  # Regression guard for the oauth2 1.x -> 2.x upgrade: oauth2 2.x changed the
  # default auth_scheme from :request_body to :basic_auth, which would move the
  # client credentials from the POST body into a Basic Authorization header.
  # BigCommerce's token endpoint expects them in the body, so assert the wire
  # behavior rather than just the option value.
  describe 'token request credential placement' do
    subject { OmniAuth::Strategies::BigCommerce.new(nil, 'the-client-id', 'the-secret') }

    let(:captured_request) { {} }

    before do
      stubs = Faraday::Adapter::Test::Stubs.new do |stub|
        stub.post('/oauth2/token') do |env|
          captured_request[:body] = env.request_body
          captured_request[:authorization] = env.request_headers['Authorization']
          [200, { 'Content-Type' => 'application/json' }, '{"access_token":"tok"}']
        end
      end
      client = subject.client
      test_connection = Faraday.new(client.site) do |builder|
        builder.request :url_encoded
        builder.adapter :test, stubs
      end
      client.instance_variable_set(:@connection, test_connection)
      allow(subject).to receive(:client).and_return(client)

      subject.client.auth_code.get_token('the-code', redirect_uri: 'https://app.example/callback')
    end

    it 'sends the client credentials in the request body' do
      expect(captured_request[:body]).to include('client_id=the-client-id')
      expect(captured_request[:body]).to include('client_secret=the-secret')
    end

    it 'does not send the client credentials in a Basic Authorization header' do
      expect(captured_request[:authorization]).to be_nil
    end
  end
end
