require 'rack/test'

RSpec.describe 'Form errors' do
  include Rack::Test::Methods
  include RackTestApp

  describe 'GET /j - Jump Page with an invalid url' do
    it 'succeds' do
      get '/j?u=blabla'
      expect(last_response).to be_ok
      expect(last_response.body).to include("The specified url isn't supported!")
    end
  end

end
