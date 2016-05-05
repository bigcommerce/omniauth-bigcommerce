require 'spec_helper'

RSpec.describe OmniAuth::Strategies::BigCommerce do
  let(:store_hash) { 'abcdefg' }
  let(:context) { "stores/#{store_hash}" }
  let(:scope) { 'store_v2_products' }
  let(:request) { double('Request', :params => { 'context' => context, 'scope' => scope }, :cookies => {}, :env => {}) }

  before do
    OmniAuth.config.test_mode = true
    allow(subject).to receive(:request).and_return(request)
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
        allow(subject).to receive(:script_name).and_return('')
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
    end
  end
end
