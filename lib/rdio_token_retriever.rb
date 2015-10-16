require 'singleton'
require 'httparty'

class RdioTokenRetriever
  include Singleton
  include HTTParty

  attr_accessor :client_id, :client_secret

  def initialize
    self.client_id      =  ENV['RDIO_CLIENT_ID']
    self.client_secret  =  ENV['RDIO_CLIENT_SECRET']
  end

  def token
    @token ||= nil
    return @token if @token

    response = self.class.post(
      "https://services.rdio.com/oauth2/token",
      body: {
        grant_type: 'client_credentials'
      },
      basic_auth: {
        username: self.client_id,
        password: self.client_secret
      }
    )

    @token = response.parsed_response["access_token"]
  end

end
