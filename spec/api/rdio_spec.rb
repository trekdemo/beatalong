require 'api/rdio'

module Api
  RSpec.describe Rdio do
    include InternalStructuresFactory

    describe '#find' do

      context 'when identity belongs to an artist' do
        let(:identity) { build_pi('Rdio', '/artist/Disclosure/', 'artist') }

        specify { expect(subject.find(identity)).to be_a(ProviderEntity) }

        it 'returns with the meta data of the artist' do
          expect(subject.find(identity).artist).to eq('Disclosure')
          expect(subject.find(identity).album).to be_nil
          expect(subject.find(identity).track).to be_nil
          expect(subject.find(identity).kind).to eq('artist')
          expect(subject.find(identity).url).to eq('http://rd.io/x/Qi1OQMY/')
        end

      end

      context 'when identity belongs to an album' do
        let(:identity) { build_pi('Rdio', '/artist/Disclosure/album/Caracal_(Deluxe)/', 'album') }

        specify { expect(subject.find(identity)).to be_a(ProviderEntity) }

        it 'returns with the meta data of the album' do
          expect(subject.find(identity).artist).to eq('Disclosure')
          expect(subject.find(identity).album).to eq('Caracal (Deluxe)')
          expect(subject.find(identity).track).to be_nil
          expect(subject.find(identity).kind).to eq('album')
          expect(subject.find(identity).url).to eq('http://rd.io/x/Qj4cRQM/')
        end

      end

      context 'when identity belongs to a track' do
        let(:identity) { build_pi('Rdio', '/artist/Disclosure/album/Caracal_(Deluxe)/track/Hourglass/', 'track') }

        specify { expect(subject.find(identity)).to be_a(ProviderEntity) }

        it 'returns with the meta data of the track' do
          expect(subject.find(identity).artist).to eq('Disclosure')
          expect(subject.find(identity).album).to eq('Caracal (Deluxe)')
          expect(subject.find(identity).track).to eq('Hourglass')
          expect(subject.find(identity).kind).to eq('track')
          expect(subject.find(identity).url).to eq('http://rd.io/x/QitGQJXF/')
        end

      end

    end

    describe '#search' do
      context 'when looking for an artist' do
        let(:entity) { build_pe('artist', 'Disclosure') }
        subject { described_class.new.search(entity) }

        it { is_expected.to be_a(ProviderEntity) }
        it 'returns with a match' do
          expect(subject.artist).to eq('Disclosure')
          expect(subject.album).to be_nil
          expect(subject.track).to be_nil
          expect(subject.kind).to eq('artist')
          expect(subject.url).to eq('http://rd.io/x/Qi1OQMY/')
        end
      end

      context 'when looking for an album' do
        let(:entity) { build_pe('album', 'Disclosure', 'Caracal (Deluxe)') }
        subject { described_class.new.search(entity) }

        it { is_expected.to be_a(ProviderEntity) }
        it 'returns with a match' do
          expect(subject.artist).to eq('Disclosure')
          expect(subject.album).to eq('Caracal (Deluxe)')
          expect(subject.track).to be_nil
          expect(subject.kind).to eq('album')
          expect(subject.url).to eq('http://rd.io/x/Qj4cRQM/')
        end
      end

      context 'when looking for a track' do
        let(:entity) { build_pe('track', 'Disclosure', 'Caracal (Deluxe)', 'Hourglass') }
        subject { described_class.new.search(entity) }

        it { is_expected.to be_a(ProviderEntity) }
        it 'returns with a match' do
          expect(subject.artist).to eq('Disclosure')
          expect(subject.album).to eq('Caracal (Deluxe)')
          expect(subject.track).to eq('Hourglass')
          expect(subject.kind).to eq('track')
          expect(subject.url).to eq('http://rd.io/x/QitGQJXF/')
        end
      end
    end

  end
end
