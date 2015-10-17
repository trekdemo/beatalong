require 'api/apple_music'

class FakeApiClass
  include ::Api::Base
end

RSpec.describe FakeApiClass do

  describe ".clean_api_query_string" do
    [
      "Hourglass feat. LION BABE",
      "Hourglass feat. LION BABE",
      "Hourglass featuring LION BABE",
      "Hourglass (feat. LION BABE)",
    ].each do |query|
      context "when #{query}" do
        subject { described_class.new.clean_api_query_string(query) }
        it { is_expected.to eq('Hourglass') }
      end
    end
  end

end
