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
      context 'when looking for an artist' do
        let(:entity) { build_pe('artist', 'UB40') }
        subject { described_class.new.search(entity) }

        it { is_expected.to be_a(ProviderEntity) }
        it 'returns with a match' do
          expect(subject.kind).to eq('artist')
          expect(subject.artist).to eq('UB40')
          expect(subject.album).to be_nil
          expect(subject.track).to be_nil
          expect(subject.url).to eq('http://www.deezer.com/artist/165')
        end
      end

      context 'when looking for an album' do
        let(:entity) { build_pe('album', 'UB40', 'The Very Best Of') }
        subject { described_class.new.search(entity) }

        it { is_expected.to be_a(ProviderEntity) }
        it 'returns with a match' do
          expect(subject.kind).to eq('album')
          expect(subject.artist).to eq('UB40')
          expect(subject.album).to eq('The Very Best Of')
          expect(subject.track).to be_nil
          expect(subject.url).to eq('http://www.deezer.com/album/304182')
        end
      end

      context 'when looking for an track' do
        let(:entity) { build_pe('track', 'UB40', 'The Very Best Of', 'One in Ten') }
        subject { described_class.new.search(entity) }

        it { is_expected.to be_a(ProviderEntity) }
        it 'returns with a match' do
          expect(subject.kind).to eq('track')
          expect(subject.artist).to eq('UB40')
          expect(subject.album).to eq('The Very Best Of UB40')
          expect(subject.track).to eq('One in Ten')
          expect(subject.url).to eq('http://www.deezer.com/track/3129575')
        end
      end
    end
  end
end
