require 'url_identity_resolver/spotify'

module UrlIdentityResolver
  RSpec.describe Spotify do
    describe '.match?' do
      [
        'https://play.spotify.com/track/3Gj9fDlYMnONY94QG1MDq9?play=true&utm_source=open.spotify.com&utm_medium=open',
        'http://play.spotify.com/track/3Gj9fDlYMnONY94QG1MDq9?play=true&utm_source=open.spotify.com&utm_medium=open',
        'spotify:track:7fifF6dzBsO33NvhIMx2ZJ',
      ].each do |url|
        context "when #{url.inspect}" do
          subject { described_class.match?(url) }
          it { is_expected.to be true }
        end
      end
    end

    describe '#call' do
      subject { described_class.new(url) }

      context 'when url is a desktop url' do
        let(:url) { 'spotify:track:7fifF6dzBsO33NvhIMx2ZJ' }

        it 'fetches the identifier and kind from the provider' do
          expect(subject.id).to eq('7fifF6dzBsO33NvhIMx2ZJ')
          expect(subject.kind).to eq('track')
        end
      end

      context 'when url leads to an artist' do
        let(:url) { 'https://play.spotify.com/artist/7c5qu1gNlg8jWDzzmlp89O' }

        it 'fetches the identifier and kind from the provider' do
          expect(subject.id).to eq('7c5qu1gNlg8jWDzzmlp89O')
          expect(subject.kind).to eq('artist')
        end
      end
    end
  end
end
