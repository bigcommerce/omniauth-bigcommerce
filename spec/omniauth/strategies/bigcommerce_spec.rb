require 'spec_helper'

RSpec.describe OmniAuth::Strategies::BigCommerce do
  subject do
    OmniAuth::Strategies::BigCommerce.new({})
  end

  before do
    OmniAuth.config.test_mode = true
  end

  after do
    OmniAuth.config.test_mode = false
  end

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
    
    it 'should use no query string for callback url' do
      request = double('Request', :params => {}, :cookies => {}, :env => {})
      allow(request).to receive(:scheme).and_return('http')
      allow(request).to receive(:url).and_return('http://example.com')

      allow(subject).to receive(:request).and_return(request)
      allow(subject).to receive(:script_name).and_return('')

      subject.callback_url
    end
  end

  describe 'authorize options' do
    let(:context) { 'stores/abcdefg' }
    let(:scope) { 'store_v2_products' }

    it 'should set the context and scope parameters in the authorize request' do
      allow(subject).to receive(:request) do
        double('Request', :params => {'context' => context, 'scope' => scope}, :cookies => {}, :env => {})
      end
      expect(subject.authorize_params['context']).to eq(context)
      expect(subject.authorize_params['scope']).to eq(scope)
    end
  end

  describe 'token options' do
    let(:context) { 'stores/abcdefg' }
    let(:scope) { 'store_v2_products' }

    it 'should set the context and scope parameters in the token request' do
      allow(subject).to receive(:request) do
        double('Request', :params => {'context' => context, 'scope' => scope}, :cookies => {}, :env => {})
      end
      expect(subject.token_params['context']).to eq(context)
      expect(subject.token_params['scope']).to eq(scope)
    end
  end
end
