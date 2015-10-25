require 'url_identity_resolver/apple_music'

module UrlIdentityResolver
  RSpec.describe AppleMusic do
    describe '.match?' do
      [
        # artist
        'https://itunes.apple.com/nl/artist/kellerkind/id290891328?l=en',
        # album
        'https://itunes.apple.com/nl/album/caracal-deluxe/id1002029534?l=en',
        'http://itunes.apple.com/nl/album/caracal-deluxe/id1002029534?l=en',
        # track
        'https://itun.es/nl/EhCU7?i=1002030097',
        'http://itun.es/nl/EhCU7?i=1002030097',
        'https://itunes.apple.com/nl/album/caracal-deluxe/id1002029534?i=1002030097&l=en',
        'http://itunes.apple.com/nl/album/caracal-deluxe/id1002029534?i=1002030097&l=en',
        # playlist
        'https://itunes.apple.com/nl/playlist/amsterdam-dance-event-amsterdam/idpl.633ff1b81d3046138a4b384c717762d9?l=en',
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
        # https://itunes.apple.com/nl/album/youre-mine-feat.-oscar-wolf/id972394188?l=en
        let(:url) { 'https://itun.es/nl/m7y95' }

        it 'resolves the url and fetches the attributes' do
          expect { subject }
            .to raise_error(Beatalong::ShortUrlError) { |e|
            expect(e.long_url).to eq('https://itunes.apple.com/nl/album/youre-mine-feat.-oscar-wolf/id972394188?l=en')
          }
        end
      end

      # http://www.apple.com/itunes/affiliates/resources/documentation/linking-to-the-itunes-music-store.html#CleanLinksDeconstructed
      context 'when the url is a clean url' do
        context 'and it leads to an artist' do
          let(:url) { 'https://itunes.apple.com/nl/artist/ub40/id524856?l=en' }

          it 'fetches the identifier of the artist' do
            expect(subject.id).to eq('524856')
            expect(subject.kind).to eq('artist')
            expect(subject.country_code).to eq('nl')
          end
        end

        context 'and it leads to an album' do
          let(:url) { 'https://itunes.apple.com/nl/album/no-memory-time-featuring-joe/id257725589?l=en' }

          it 'fetches the identifier of the album' do
            expect(subject.id).to eq('257725589')
            expect(subject.kind).to eq('album')
            expect(subject.country_code).to eq('nl')
          end
        end

        context 'and it leads to a track' do
          let(:url) { 'https://itunes.apple.com/nl/album/the-very-best-of-ub40-1980-2000/id724633277?i=724633596&l=en' }

          it 'fetches the identifier of the track' do
            expect(subject.id).to eq('724633596')
            expect(subject.kind).to eq('track')
            expect(subject.country_code).to eq('nl')
          end
        end
      end
    end
  end
end
