require 'url_identity_resolver/soundcloud'

module UrlIdentityResolver
  RSpec.describe Soundcloud do
    describe '.match?' do
      [
        'https://soundcloud.com/spinnin-deep/sam-feldt-show-me-love-edxs-indian-summer-remix-available-june-1',
        'http://www.soundcloud.com/spinnin-deep/sam-feldt-show-me-love-edxs-indian-summer-remix-available-june-1',
      ].each do |url|
        context "when #{url.inspect}" do
          subject { described_class.match?(url) }
          it { is_expected.to be true }
        end
      end
    end

    describe '#call' do
      subject { described_class.new(url) }

      context 'when the url is a normal url' do
        context 'and it leads to an artist' do
          let(:url) { 'https://soundcloud.com/gelka' }

          it 'fetches the identifier of the artist' do
            expect(subject.id).to eq(url)
            expect(subject.kind).to eq('artist')
          end
        end

        context 'and it leads to a track' do
          let(:url) { 'https://soundcloud.com/gelka/gelka-feat-sena-these-days-2' }

          it 'fetches the identifier of the track' do
            expect(subject.id).to eq(url)
            expect(subject.kind).to eq('track')
          end
        end

      end
    end
  end
end
