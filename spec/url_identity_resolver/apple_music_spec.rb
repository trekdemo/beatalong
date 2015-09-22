require 'url_identity_resolver/apple_music'

module UrlIdentityResolver
  RSpec.describe AppleMusic do
    subject { described_class.new('https://itun.es/nl/vsjxp') }

    describe '#call' do
      it 'fetches the identifier from the provider' do
        expect(subject.call).to eq('257725589')
      end
    end
  end
end
