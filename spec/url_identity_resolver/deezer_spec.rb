require 'url_identity_resolver/deezer'

module UrlIdentityResolver
  RSpec.describe Deezer do
    subject { described_class.new('http://www.deezer.com/track/90418035') }

    describe '#call' do
      it 'fetches the identifier and kind from the provider' do
        subject.call
        expect(subject.id).to eq('90418035')
        expect(subject.kind).to eq('track')
      end
    end
  end
end
