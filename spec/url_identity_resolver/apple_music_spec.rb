require 'url_identity_resolver/apple_music'

module UrlIdentityResolver
  RSpec.describe AppleMusic do
    describe '#call' do
      it 'fetches the identifier from the provider when a hidden url is provided' do
        subject = described_class.new('https://itun.es/nl/vsjxp')

        expect(subject.id).to eq('257725589')
        expect(subject.kind).to eq(nil)
      end

      it 'fetches the identifier from the provider when an unpacked url is provided' do
        subject = described_class.new('https://itunes.apple.com/nl/album/no-memory-time-featuring-joe/id257725589?l=en')

        expect(subject.id).to eq('257725589')
        expect(subject.kind).to eq(nil)
      end
    end
  end
end
