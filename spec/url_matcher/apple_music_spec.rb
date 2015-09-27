require 'url_matcher/apple_music'

module UrlMatcher
  RSpec.describe AppleMusic do
    describe '#match?' do
      [
        'https://itun.es/nl/EhCU7?i=1002030097',
        'https://itunes.apple.com/nl/album/caracal-deluxe/id1002029534?i=1002030097&l=en',
        'http://itun.es/nl/EhCU7?i=1002030097',
        'http://itunes.apple.com/nl/album/caracal-deluxe/id1002029534?i=1002030097&l=en',
      ].each do |url|
        context "when #{url.inspect}" do
          subject { described_class.new(url) }
          it { is_expected.to be_match }
        end
      end
    end
  end
end
