require 'api/deezer'

module Api
  RSpec.describe Deezer do
    include InternalStructuresFactory

    describe '#find' do
      context 'when identity belongs to an artist' do
        let(:identity) { build_pi('Deezer', '119', 'artist') }

        specify { expect(subject.find(identity)).to be_a(ProviderEntity) }

        it 'returns with the meta data of the artist' do
          expect(subject.find(identity).artist).to eq('Metallica')
          expect(subject.find(identity).album).to be_nil
          expect(subject.find(identity).track).to be_nil
          expect(subject.find(identity).kind).to eq('artist')
          expect(subject.find(identity).url).to eq('http://www.deezer.com/artist/119')
        end
      end

      context 'when identity belongs to an album' do
        let(:identity) { build_pi('Deezer', '9426892', 'album') }

        specify { expect(subject.find(identity)).to be_a(ProviderEntity) }

        it 'returns with the meta data of the album' do
          expect(subject.find(identity).artist).to eq('NOFX')
          expect(subject.find(identity).album).to eq('Backstage Passport Soundtrack')
          expect(subject.find(identity).track).to be_nil
          expect(subject.find(identity).kind).to eq('album')
          expect(subject.find(identity).url).to eq('http://www.deezer.com/album/9426892')
        end
      end

      context 'when identity belongs to a track' do
        let(:identity) { build_pi('Deezer', '92876026', 'track') }

        specify { expect(subject.find(identity)).to be_a(ProviderEntity) }

        it 'returns with the meta data of the album' do
          expect(subject.find(identity).artist).to eq('NOFX')
          expect(subject.find(identity).album).to eq('Backstage Passport Soundtrack')
          expect(subject.find(identity).track).to eq('No Fun in Fundamentalism')
          expect(subject.find(identity).kind).to eq('track')
          expect(subject.find(identity).url).to eq('http://www.deezer.com/track/92876026')
        end
      end
    end

    describe '#search' do

    end
  end
end
