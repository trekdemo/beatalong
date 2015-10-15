require 'url_identity_resolver/deezer'

module UrlIdentityResolver
  RSpec.describe Deezer do
    subject { described_class.new('http://www.deezer.com/track/90418035') }

    describe '.match?' do
      [
        # artist
        'http://www.deezer.com/artist/119?utm_source=deezer&utm_content=artist-119&utm_term=21874898_1444459553&utm_medium=web',
        # album
        'http://www.deezer.com/album/11176202?utm_source=deezer&utm_content=album-11176202&utm_term=21874898_1444459600&utm_medium=web',
        # track
        'http://www.deezer.com/track/107198152?utm_source=deezer&utm_content=track-107198152&utm_term=21874898_1444459631&utm_medium=web',
      ].each do |url|
        context "when #{url.inspect}" do
          subject { described_class.match?(url) }
          it { is_expected.to be true }
        end
      end
    end

    describe '#call' do
      it 'fetches the identifier and kind from the provider' do
        expect(subject.id).to eq('90418035')
        expect(subject.kind).to eq('track')
      end
    end
  end
end
