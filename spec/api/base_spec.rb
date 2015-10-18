require 'api/apple_music'

class FakeApiClass
  include ::Api::Base
end

RSpec.describe FakeApiClass do

  describe ".clean_api_query_string" do
    [
      [ "Hourglass feat. LION BABE",        "Hourglass" ],
      [ "Hourglass feat. LION BABE",        "Hourglass" ],
      [ "Hourglass featuring LION BABE",    "Hourglass" ],
      [ "Hourglass (feat. LION BABE)",      "Hourglass" ],
      [ "Splitting the Atom - EP",          "Splitting the Atom" ],
      [ "Swimming Pools (Drank) - Single",  "Swimming Pools Drank" ],
    ].each do |query|
      context "cleaning query string #{query[0]}" do
        subject { described_class.new.clean_api_query_string(query[0]) }
        it { is_expected.to eq(query[1]) }
      end
    end

  end

end
