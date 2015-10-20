require 'rack/test'

OUTER_APP = Rack::Builder.parse_file('config.ru').first

RSpec.describe 'Form errors' do
  include Rack::Test::Methods

  def app
    OUTER_APP
  end

  describe 'GET /j - Jump Page with an invalid url' do
    it 'succeds' do
      get '/j?u=blabla'
      expect(last_response).to be_ok
      expect(last_response.body).to include("The specified url isn't supported!")
    end
  end

end
