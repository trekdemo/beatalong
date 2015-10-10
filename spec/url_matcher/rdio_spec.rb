require 'url_matcher/rdio'

module UrlMatcher
  RSpec.describe Rdio do
    describe '#match?' do
      [
        # artist
        'http://rd.io/x/QUx4UjFR1w/',
        'https://www.rdio.com/artist/Bob_Marley/?utm_campaign=share&utm_medium=Artist&utm_source=1260045&utm_content=3717',
        # album
        'http://rd.io/x/QUx4UiIb0A/',
        'https://www.rdio.com/artist/Bob_Marley/album/The_Anthology/',
        # track
        'http://rd.io/x/QUx4UjdcHlQ/',
        'https://www.rdio.com/artist/Bob_Marley/album/The_Anthology/track/Sun_Is_Shining/?utm_campaign=share&utm_medium=Track&utm_source=1260045&utm_content=216085',
      ].each do |url|
        context "when #{url.inspect}" do
          subject { described_class.new(url) }
          it { is_expected.to be_match }
        end
      end
    end
  end
end

