require 'rack/test'

RSpec.describe 'Form errors' do
  include Rack::Test::Methods
  include RackTestApp

  describe 'GET /j - Jump Page with an invalid url' do
    it 'succeds' do
      get '/j?u=http://foo.bar'
      follow_redirect!

      expect(last_response.body).to include("The specified url isn't supported!")
      expect(last_response).to be_ok
    end
  end

end
