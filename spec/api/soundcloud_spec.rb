require 'api/soundcloud'

module Api
  RSpec.describe Soundcloud do
    include InternalStructuresFactory

    describe '#find' do

      context 'when identity belongs to an artist' do
        let(:identity) { build_pi('Soundcloud', 'https://soundcloud.com/gelka', 'artist') }
        let(:result) { subject.find(identity)}

        specify { expect(subject.find(identity)).to be_a(ProviderEntity) }

        it 'returns with the meta data of the artist' do
          expect(result.artist).to eq('gelka')
          expect(result.album).to be_nil
          expect(result.track).to be_nil
          expect(result.kind).to eq('artist')
          expect(result.url).to eq('http://soundcloud.com/gelka')
          expect(result.cover_image_url).to eq('https://i1.sndcdn.com/avatars-000144401641-bbxfha-large.jpg')
        end

      end

      context 'when identity belongs to a track' do
        let(:identity) { build_pi('Soundcloud', 'https://soundcloud.com/gelka/gelka-feat-mozez-spell-im-in-forthcoming', 'track') }
        let(:result) { subject.find(identity)}

        specify { expect(subject.find(identity)).to be_a(ProviderEntity) }

        it 'returns with the meta data of the artist' do
          expect(result.artist).to eq('gelka')
          expect(result.album).to be_nil
          expect(result.track).to eq("Gelka feat Mozez - Spell I'm In (forthcoming)")
          expect(result.kind).to eq('track')
          expect(result.url).to eq('http://soundcloud.com/gelka/gelka-feat-mozez-spell-im-in-forthcoming')
          expect(result.cover_image_url).to eq('https://i1.sndcdn.com/artworks-000133205905-ektm24-large.jpg')
        end
      end

    end
  end
end
