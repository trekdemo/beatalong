require 'url_identity_resolver/rdio'

module UrlIdentityResolver
  RSpec.describe Rdio do
    describe '.match?' do
      [
        # artist
        'http://rd.io/x/QUx4UjFR1w/',
        'https://www.rdio.com/artist/Bob_Marley/?utm_campaign=share&utm_medium=Artist&utm_source=1260045&utm_content=3717',
        # album
        'http://rd.io/x/QUx4UiIb0A/',
        'https://www.rdio.com/artist/Bob_Marley/album/The_Anthology/',
        # track
        'http://rd.io/x/QUx4UjdcHlQ/',
        'https://www.rdio.com/artist/Bob_Marley/album/The_Anthology/track/Sun_Is_Shining/?utm_campaign=share&utm_medium=Track&utm_source=1260045&utm_content=216085',
      ].each do |url|
        context "when #{url.inspect}" do
          subject { described_class.match?(url) }
          it { is_expected.to be true }
        end
      end
    end

    describe '#call' do
      subject { described_class.new(url) }

      context 'when url is shortened' do
        # https://itunes.apple.com/nl/album/youre-mine-feat.-oscar-wolf/id972394188?&l=en
        let(:url) { 'http://rd.io/x/Rl5BAGYrVl6S0w/' }

        it 'resolves the url and fetches the attributes' do
          expect(subject.id).to eq('Rl5BAGYrVl6S0w')
        end
      end

      # http://www.apple.com/itunes/affiliates/resources/documentation/linking-to-the-itunes-music-store.html#CleanLinksDeconstructed
      context 'when the url is a clean url' do
        context 'and it leads to an artist' do
          let(:url) { 'https://www.rdio.com/artist/Disclosure/?utm_campaign=share&utm_medium=Artist&utm_source=16998181&utm_content=794501' }

          it 'fetches the identifier of the artist' do
            expect(subject.id).to eq('/artist/Disclosure/')
          end
        end

        context 'and it leads to an album' do
          let(:url) { 'https://www.rdio.com/artist/Disclosure/album/Caracal_(Deluxe)/?utm_campaign=share&utm_medium=Album&utm_source=16998181&utm_content=6167104' }

          it 'fetches the identifier of the album' do
            expect(subject.id).to eq('/artist/Disclosure/album/Caracal_(Deluxe)/')
          end
        end

        context 'and it leads to a track' do
          let(:url) { 'https://www.rdio.com/artist/Disclosure/album/Caracal_(Deluxe)/track/Hourglass/?utm_campaign=share&utm_medium=Track&utm_source=16998181&utm_content=69195418' }

          it 'fetches the identifier of the track' do
            expect(subject.id).to eq('/artist/Disclosure/album/Caracal_(Deluxe)/track/Hourglass/')
          end
        end
      end
    end
  end
end
