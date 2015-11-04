require 'api/apple_music'

module Api
  class AppleMusic
    # do not make extra requests
    def echonest_image(artist)
      nil
    end
  end

  RSpec.describe AppleMusic do
    include InternalStructuresFactory

    describe '#find' do
      context 'when identity belongs to a track' do
        let(:identity) { build_pi('AppleMusic', '724633596', 'track') }

        specify { expect(subject.find(identity)).to be_a(ProviderEntity) }

        it 'returns with the meta data of the track' do
          expect(subject.find(identity).artist).to eq('UB40')
          expect(subject.find(identity).album).to eq('The Very Best of UB40: 1980-2000')
          expect(subject.find(identity).track).to eq('Kingston Town')
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
          expect(subject.find(identity).track).to be_nil
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
          expect(subject.find(identity).track).to be_nil
          expect(subject.find(identity).kind).to eq('artist')
          expect(subject.find(identity).url).to eq('https://itunes.apple.com/nl/artist/ub40/id524856?uo=4')
        end
      end

      context 'when identity belongs to a playlist' do
        let(:identity) { build_pi('AppleMusic', 'pl.5e01462edfd74e23b80e38b9982b30d5', 'playlist') }

        specify { expect(subject.find(identity)).to be_a(ProviderPlaylist) }

        it 'returns with the meta data of the playlist' do
          playlist = subject.find(identity)

          expect(playlist.title).to eq('Chillen')
          expect(playlist.author).to eq('Apple Music Pop')
          expect(playlist.url).to eq('https://itunes.apple.com/nl/playlist/chillen/idpl.5e01462edfd74e23b80e38b9982b30d5')
          expect(playlist.tracks.size).to eq(19)

          first_track = playlist.tracks.first
          expect(first_track).to be_a ProviderEntity
          expect(first_track.artist).to eq('Beastie Boys')
          expect(first_track.album).to eq('The In Sound From Way Out!')
          expect(first_track.track).to eq('Namaste')
          expect(first_track.kind).to eq('track')
          expect(first_track.url).to eq('https://itunes.apple.com/nl/album/namaste/id724748953?i=724749360')
        end
      end

      context 'when identity belongs to a search' do
        let(:identity) { build_pi('AppleMusic', search_term, 'search') }

        context 'for an artist' do
          let(:search_term) { 'Daft Punk' }

          it 'returns with the meta data of a track' do
            track = subject.find(identity)

            expect(track).to be_a(ProviderEntity)
            expect(track.artist).to eq('Daft Punk')
            expect(track.album).to be_nil
            expect(track.track).to be_nil
            expect(track.kind).to eq('artist')
            expect(track.url).to eq('https://itunes.apple.com/nl/artist/daft-punk/id5468295?uo=4')
          end
        end

        context 'for a track' do
          let(:search_term) { 'Daft Punk - Harder Better Faster Stronger' }

          it 'returns with the meta data of a track' do
            track = subject.find(identity)

            expect(track).to be_a(ProviderEntity)
            expect(track.artist).to eq('Daft Punk')
            expect(track.album).to eq('Discovery')
            expect(track.track).to eq('Harder Better Faster Stronger')
            expect(track.kind).to eq('track')
            expect(track.url).to eq('https://itunes.apple.com/nl/album/harder-better-faster-stronger/id697194953?i=697195787&uo=4')
          end
        end
      end
    end

    describe '#search' do
      context 'when looking for an artist' do
        let(:entity) { build_pe('artist', 'UB40') }
        subject { described_class.new('nl').search(entity) }

        it { is_expected.to be_a(ProviderEntity) }
        it 'returns with a match' do
          expect(subject.artist).to eq('UB40')
          expect(subject.album).to be_nil
          expect(subject.track).to be_nil
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
          expect(subject.track).to be_nil
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
          expect(subject.track).to eq('Kingston Town')
          expect(subject.kind).to eq('track')
          expect(subject.url).to eq('https://itunes.apple.com/nl/album/kingston-town/id724633277?i=724633596&uo=4')
        end
      end
    end
  end
end
