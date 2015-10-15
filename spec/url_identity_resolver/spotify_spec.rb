require 'url_identity_resolver/spotify'

module UrlIdentityResolver
  RSpec.describe Spotify do
    subject { described_class.new('https://play.spotify.com/artist/7c5qu1gNlg8jWDzzmlp89O') }

    describe '.match?' do
      [
        'https://play.spotify.com/track/3Gj9fDlYMnONY94QG1MDq9?play=true&utm_source=open.spotify.com&utm_medium=open',
        'http://sptfy.com/1iVR',
        'http://play.spotify.com/track/3Gj9fDlYMnONY94QG1MDq9?play=true&utm_source=open.spotify.com&utm_medium=open',
        'https://sptfy.com/1iVR',
      ].each do |url|
        context "when #{url.inspect}" do
          subject { described_class.match?(url) }
          it { is_expected.to be true }
        end
      end
    end

    describe '#call' do
      it 'fetches the identifier and kind from the provider' do
        expect(subject.id).to eq('7c5qu1gNlg8jWDzzmlp89O')
        expect(subject.kind).to eq('artist')
      end
    end
  end
end
