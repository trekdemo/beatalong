require 'api/apple_music'
require 'provider_identity'

module Api
  RSpec.describe AppleMusic do
    describe '.find' do
      context 'when identity belongs to a track' do
        let(:identity) { ProviderIdentity.new(provider: 'AppleMusic', id: '724633596', kind: 'track', country_code: 'nl') }

        specify { expect(subject.find(identity)).to be_a(ProviderEntity) }

        it 'returns with the meta data of the track' do
          expect(subject.find(identity).artist).to eq('UB40')
          expect(subject.find(identity).album).to eq('The Very Best of UB40: 1980-2000')
          expect(subject.find(identity).title).to eq('Kingston Town')
          expect(subject.find(identity).kind).to eq('track')
          expect(subject.find(identity).url).to eq('https://itunes.apple.com/nl/album/kingston-town/id724633277?i=724633596&uo=4')
        end
      end

      context 'when identity belongs to an album' do
        let(:identity) { ProviderIdentity.new(provider: 'AppleMusic', id: '724633277', kind: 'album', country_code: 'nl') }

        specify { expect(subject.find(identity)).to be_a(ProviderEntity) }

        it 'returns with the meta data of the album' do
          expect(subject.find(identity).artist).to eq('UB40')
          expect(subject.find(identity).album).to eq('The Very Best of UB40: 1980-2000')
          expect(subject.find(identity).title).to be_nil
          expect(subject.find(identity).kind).to eq('album')
          expect(subject.find(identity).url).to eq('https://itunes.apple.com/nl/album/the-very-best-of-ub40-1980-2000/id724633277?uo=4')
        end
      end

      context 'when identity belongs to an artist' do
        let(:identity) { ProviderIdentity.new(provider: 'AppleMusic', id: '524856', kind: 'artist', country_code: 'nl') }

        specify { expect(subject.find(identity)).to be_a(ProviderEntity) }

        it 'returns with the meta data of the album' do
          expect(subject.find(identity).artist).to eq('UB40')
          expect(subject.find(identity).album).to be_nil
          expect(subject.find(identity).title).to be_nil
          expect(subject.find(identity).kind).to eq('artist')
          expect(subject.find(identity).url).to eq('https://itunes.apple.com/nl/artist/ub40/id524856?uo=4')
        end
      end
    end

    describe '.search' do

    end
  end
end
