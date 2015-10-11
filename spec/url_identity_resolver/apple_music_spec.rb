require 'url_identity_resolver/apple_music'

module UrlIdentityResolver
  RSpec.describe AppleMusic do
    describe '#call' do
      subject { described_class.new(url) }

      context 'when url is shortened' do
        # https://itunes.apple.com/nl/album/no-memory-time-featuring-joe/id257725589?l=en
        let(:url) { 'https://itun.es/nl/vsjxp' }

        it 'resolves the url and fetches the attributes' do
          expect(subject.id).to eq('257725589')
          expect(subject.kind).to eq('album')
          expect(subject.country_code).to eq('nl')
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
