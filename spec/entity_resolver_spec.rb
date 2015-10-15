require 'entity_resolver'

RSpec.describe EntityResolver do
  describe '.identity_from' do
    subject { described_class.identity_from(url) }

    context 'when provider is AppleMusic' do
      {
        'https://itunes.apple.com/nl/artist/kellerkind/id290891328?l=en' =>
          ['AppleMusic', '290891328', 'artist'],
        'https://itunes.apple.com/nl/album/caracal-deluxe/id1002029534?l=en' =>
          ['AppleMusic', '1002029534', 'album'],
        'https://itunes.apple.com/nl/album/caracal-deluxe/id1002029534?i=1002030097&l=en' =>
          ['AppleMusic', '1002030097', 'track'],
      }.each_pair do |url, identity|
        context url.inspect do
          let(:url) { url }
          specify { expect(subject.to_a).to eq(identity) }
        end
      end
    end

    context 'when provider is Deezer' do
      {
        'http://www.deezer.com/artist/119'      => ['Deezer', '119', 'artist'],
        'http://www.deezer.com/album/11176202'  => ['Deezer', '11176202', 'album'],
        'http://www.deezer.com/track/107198152' => ['Deezer', '107198152', 'track'],
      }.each_pair do |url, identity|
        context url.inspect do
          let(:url) { url }
          specify { expect(subject.to_a).to eq(identity) }
        end
      end
    end

    context 'when provider is Spotify' do
      {
        'https://play.spotify.com/artist/2ye2Wgw4gimLv2eAKyk1NB' => ['Spotify', '2ye2Wgw4gimLv2eAKyk1NB', 'artist'],
        'https://play.spotify.com/album/72grIwGP38Iy2S1jxt1Gjd'  => ['Spotify', '72grIwGP38Iy2S1jxt1Gjd', 'album'],
        'https://play.spotify.com/track/2MzaSLi8iFWQQ7fBE3rvDe'  => ['Spotify', '2MzaSLi8iFWQQ7fBE3rvDe', 'track'],
      }.each_pair do |url, identity|
        context url.inspect do
          let(:url) { url }
          specify { expect(subject.to_a).to eq(identity) }
        end
      end
    end

    context 'when provider is Rdio'

    context 'when provider is UNKNOWN' do
      let(:url) { 'https://google.com' }
      it { is_expected.to be_nil }
    end
  end
end
