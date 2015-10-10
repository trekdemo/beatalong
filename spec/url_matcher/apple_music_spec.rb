require 'url_matcher/apple_music'

module UrlMatcher
  RSpec.describe AppleMusic do
    describe '#match?' do
      [
        # artist
        'https://itunes.apple.com/nl/artist/kellerkind/id290891328?l=en',
        # album
        'https://itunes.apple.com/nl/album/caracal-deluxe/id1002029534?l=en',
        'http://itunes.apple.com/nl/album/caracal-deluxe/id1002029534?l=en',
        # track
        'https://itun.es/nl/EhCU7?i=1002030097',
        'http://itun.es/nl/EhCU7?i=1002030097',
        'https://itunes.apple.com/nl/album/caracal-deluxe/id1002029534?i=1002030097&l=en',
        'http://itunes.apple.com/nl/album/caracal-deluxe/id1002029534?i=1002030097&l=en',
        # playlist
        'https://itunes.apple.com/nl/playlist/amsterdam-dance-event-amsterdam/idpl.633ff1b81d3046138a4b384c717762d9?l=en',
      ].each do |url|
        context "when #{url.inspect}" do
          subject { described_class.new(url) }
          it { is_expected.to be_match }
        end
      end
    end
  end
end
