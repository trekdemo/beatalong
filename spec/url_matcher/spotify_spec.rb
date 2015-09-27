require 'url_matcher/spotify'

module UrlMatcher
  RSpec.describe Spotify do
    describe '#match?' do
      [
        'https://play.spotify.com/track/3Gj9fDlYMnONY94QG1MDq9?play=true&utm_source=open.spotify.com&utm_medium=open',
        'http://sptfy.com/1iVR',
        'http://play.spotify.com/track/3Gj9fDlYMnONY94QG1MDq9?play=true&utm_source=open.spotify.com&utm_medium=open',
        'https://sptfy.com/1iVR',
      ].each do |url|
        context "when #{url.inspect}" do
          subject { described_class.new(url) }
          it { is_expected.to be_match }
        end
      end
    end
  end
end
