require 'api/spotify'

module Api
  RSpec.describe Spotify do
    include InternalStructuresFactory

    describe '#find' do
      context 'when identity belongs to an artist' do
        let(:identity) { build_pi('Spotify', '2ye2Wgw4gimLv2eAKyk1NB', 'artist') }

        specify { expect(subject.find(identity)).to be_a(ProviderEntity) }

        it 'returns with the meta data of the artist' do
          expect(subject.find(identity).artist).to eq('Metallica')
          expect(subject.find(identity).album).to be_nil
          expect(subject.find(identity).track).to be_nil
          expect(subject.find(identity).kind).to eq('artist')
          expect(subject.find(identity).url).to eq('https://open.spotify.com/artist/2ye2Wgw4gimLv2eAKyk1NB')
        end
      end

      context 'when identity belongs to an album' do
        let(:identity) { build_pi('Spotify', '3wAdN3V06Btox7NjFfBKRC', 'album') }

        specify { expect(subject.find(identity)).to be_a(ProviderEntity) }

        it 'returns with the meta data of the album' do
          expect(subject.find(identity).artist).to eq('Metallica')
          expect(subject.find(identity).album).to eq('Death Magnetic')
          expect(subject.find(identity).track).to be_nil
          expect(subject.find(identity).kind).to eq('album')
          expect(subject.find(identity).url).to eq('https://open.spotify.com/album/3wAdN3V06Btox7NjFfBKRC')
        end
      end

      context 'when identity belongs to a track' do
        let(:identity) { build_pi('Spotify', '1FNZq0NV4yymW1wEjIi2eY', 'track') }

        specify { expect(subject.find(identity)).to be_a(ProviderEntity) }

        it 'returns with the meta data of the album' do
          expect(subject.find(identity).artist).to eq('Metallica')
          expect(subject.find(identity).album).to eq('Death Magnetic')
          expect(subject.find(identity).track).to eq('That Was Just Your Life')
          expect(subject.find(identity).kind).to eq('track')
          expect(subject.find(identity).url).to eq('https://open.spotify.com/track/1FNZq0NV4yymW1wEjIi2eY')
        end
      end
    end
  end
end

