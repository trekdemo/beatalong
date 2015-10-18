require 'api/cached'

module Api
  RSpec.describe Cached do
    include InternalStructuresFactory

    subject { described_class.new(mock_adapter) }
    let(:mock_adapter) { double }

    describe '#find' do
      let(:identity) { build_pi('dummy', '1', 'track') }

      it 'delegates the calls to the adapter' do
        expect(mock_adapter).to receive(:find).with(identity)

        subject.find(identity)
      end
    end

    describe '#search' do
      it 'delegates the calls to the adapter' do
        expect(mock_adapter).to receive(:search).with(:argument)

        subject.search(:argument)
      end
    end
  end
end
