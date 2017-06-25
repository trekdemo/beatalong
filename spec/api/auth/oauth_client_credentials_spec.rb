require 'api/auth/oauth_client_credentials'

module Api
  module Auth
    RSpec.describe OauthClientCredentials, { vcr: { record: :skip } } do
      let(:fake_redis) { Redis.new }
      let(:url) { 'https://test.local/api/token' }
      let(:client_id) { 'client_id_value' }
      let(:client_secret) { 'client_secret_value' }
      subject do
        described_class.new(cache_provider: fake_redis,
          url: url, client_id: client_id, client_secret: client_secret)
      end

      describe '#token' do
        context 'when token is cached' do
          before { fake_redis.set('provider:auth:test.local:token', '123X') }

          it 'returns cached value' do
            expect(subject.token).to eq '123X'
          end

          it 'does not initiate http post' do
            expect(subject).not_to receive(:fetch_new_access_token)

            subject.token
          end
        end

        context 'when token is not cached' do
          before do
            fake_redis.del('provider:auth:test.local:token')
            stub_request(:post, "#{url}?grant_type=client_credentials")
              .with(headers:
                {
                  Authorization: 'Basic Y2xpZW50X2lkX3ZhbHVlOmNsaWVudF9zZWNyZXRfdmFsdWU='
                })
              .to_return(response)
          end

          context 'when successful' do
            let(:response) do
              {
                body: {
                  access_token: '456Y',
                  expires_in: 3600
                }.to_json,
                status: 200
              }
            end

            it 'fetches and returns new token' do
              expect(subject.token).to eq '456Y'
            end

            it 'caches new token' do
              subject.token

              expect(fake_redis.get('provider:auth:test.local:token')).to eq '456Y'
            end
          end

          context 'when failed' do
            let(:response) { { body: 'xy', status: 400 } }

            it 'sends error to rollbar' do
              expect(Rollbar).to receive(:error).with('Unable to get oauth token', {
                api_url: url,
                response_code: 400,
                response_body: 'xy'
              })

              expect(subject.token).to be_nil
            end
          end
        end
      end
    end
  end
end
