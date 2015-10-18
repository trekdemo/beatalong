require 'rack/test'

OUTER_APP = Rack::Builder.parse_file('config.ru').first

RSpec.describe 'Smoke' do
  include Rack::Test::Methods

  def app
    OUTER_APP
  end

  describe 'GET / - Home Page' do
    it 'succeds' do
      get '/'
      expect(last_response).to be_ok
      expect(last_response.body).to include('Share your favorite music with your friends!')
    end
  end

  describe 'GET /j - Jump Page' do
    it 'succeds' do
      get '/j?u=http://www.deezer.com/track/107198152'
      expect(last_response).to be_ok
      expect(last_response.body).to include('Fade to Black (Live)')
    end
  end

  describe 'GET /r - Redirect' do
    it 'succeds' do
      get '/r/apple_music?u=http://www.deezer.com/track/3129575'
      expect(last_response).to be_redirect
      expect(last_response.location).to_not be_nil
    end
  end
end
