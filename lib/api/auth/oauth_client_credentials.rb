require 'base64'
require 'httparty'
require 'logger'
require 'rollbar'

module Api
  module Auth
    class OauthClientCredentials
      attr_reader :cache_provider, :logger, :url, :client_id, :client_secret

      def initialize(cache_provider:, logger: Logger.new(nil),
        url:, client_id:, client_secret:)

        @cache_provider = cache_provider
        @logger = logger
        @url = url
        @client_id = client_id
        @client_secret = client_secret
      end

      def token
        logger.info { "Get oauth token from #{url}" }
        access_token = cache_provider.get(cache_key)
        logger.info { "Use token from cache=#{!access_token.nil?}" }
        return access_token unless access_token.nil?

        fetch_new_access_token
      end

      private

      def fetch_new_access_token
        response = HTTParty.post(url,
                     query: { 'grant_type' => 'client_credentials' },
                     headers: { 'Authorization' => "Basic #{auth}" })

        logger.info { "HTTP token response=#{response.code}" }

        if response.code == 200
          json = JSON.parse(response.body)
          cache_result(json)
          json['access_token']
        else
          report_error(response)
          nil
        end
      end

      def auth
        Base64.strict_encode64("#{client_id}:#{client_secret}").chomp
      end

      def cache_result(response)
        expires_in_sec = response['expires_in'].to_i - 60
        logger.info { "Cache auth response key=#{cache_key}, expires_in (s): #{expires_in_sec}" }
        cache_provider.set(cache_key, response['access_token'],
          ex: expires_in_sec)
      end

      def cache_key
        @cache_key ||= begin
          host = URI.parse(url).host
          "provider:auth:#{host}:token"
        end
      end

      def report_error(response)
        Rollbar.error 'Unable to get oauth token', {
          api_url: url,
          response_code: response.code,
          response_body: response.body
        }
      end
    end
  end
end
