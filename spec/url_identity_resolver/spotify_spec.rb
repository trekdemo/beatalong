require 'url_identity_resolver/spotify'

module UrlIdentityResolver
  RSpec.describe Spotify do
    subject { described_class.new('https://play.spotify.com/artist/7c5qu1gNlg8jWDzzmlp89O') }

    describe '#call' do
      it 'fetches the identifier and kind from the provider' do
        expect(subject.id).to eq('7c5qu1gNlg8jWDzzmlp89O')
        expect(subject.kind).to eq('artist')
      end
    end
  end
end
