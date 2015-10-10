require 'url_matcher/deezer'

module UrlMatcher
  RSpec.describe Deezer do
    describe '#match?' do
      [
        # artist
        'http://www.deezer.com/artist/119?utm_source=deezer&utm_content=artist-119&utm_term=21874898_1444459553&utm_medium=web',
        # album
        'http://www.deezer.com/album/11176202?utm_source=deezer&utm_content=album-11176202&utm_term=21874898_1444459600&utm_medium=web',
        # track
        'http://www.deezer.com/track/107198152?utm_source=deezer&utm_content=track-107198152&utm_term=21874898_1444459631&utm_medium=web',
      ].each do |url|
        context "when #{url.inspect}" do
          subject { described_class.new(url) }
          it { is_expected.to be_match }
        end
      end
    end
  end
end
