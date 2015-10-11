require 'api/apple_music'

module Api
  RSpec.describe AppleMusic do
    include InternalStructuresFactory

    describe '.find' do
      context 'when identity belongs to a track' do
        let(:identity) { build_pi('AppleMusic', '724633596', 'track') }

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
        let(:identity) { build_pi('AppleMusic', '724633277', 'album') }

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
        let(:identity) { build_pi('AppleMusic', '524856', 'artist') }

        specify { expect(subject.find(identity)).to be_a(ProviderEntity) }

        it 'returns with the meta data of the artist' do
          expect(subject.find(identity).artist).to eq('UB40')
          expect(subject.find(identity).album).to be_nil
          expect(subject.find(identity).title).to be_nil
          expect(subject.find(identity).kind).to eq('artist')
          expect(subject.find(identity).url).to eq('https://itunes.apple.com/nl/artist/ub40/id524856?uo=4')
        end
      end
    end

    describe '.search' do
      context 'when looking for an artist' do
        let(:entity) { build_pe('artist', 'UB40') }
        subject { described_class.new('nl').search(entity) }

        it { is_expected.to be_a(ProviderEntity) }
        it 'returns with a match' do
          expect(subject.artist).to eq('UB40')
          expect(subject.album).to be_nil
          expect(subject.title).to be_nil
          expect(subject.kind).to eq('artist')
          expect(subject.url).to eq('https://itunes.apple.com/nl/artist/ub40/id524856?uo=4')
        end
      end

      context 'when looking for an album' do
        let(:entity) { build_pe('album', 'UB40', 'The Very Best of UB40: 1980-2000') }
        subject { described_class.new('nl').search(entity) }

        it { is_expected.to be_a(ProviderEntity) }
        it 'returns with a match' do
          expect(subject.artist).to eq('UB40')
          expect(subject.album).to eq('The Very Best of UB40: 1980-2000')
          expect(subject.title).to be_nil
          expect(subject.kind).to eq('album')
          expect(subject.url).to eq('https://itunes.apple.com/nl/album/the-very-best-of-ub40-1980-2000/id724633277?uo=4')
        end
      end

      context 'when looking for a track' do
        let(:entity) { build_pe('track', 'UB40', 'The Very Best of UB40: 1980-2000', 'Kingston Town') }
        subject { described_class.new('nl').search(entity) }

        it { is_expected.to be_a(ProviderEntity) }
        it 'returns with a match' do
          expect(subject.artist).to eq('UB40')
          expect(subject.album).to eq('The Very Best of UB40: 1980-2000')
          expect(subject.title).to eq('Kingston Town')
          expect(subject.kind).to eq('track')
          expect(subject.url).to eq('https://itunes.apple.com/nl/album/kingston-town/id724633277?i=724633596&uo=4')
        end
      end
    end
  end
end
