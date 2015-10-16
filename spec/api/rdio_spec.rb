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
    end
  end
end
