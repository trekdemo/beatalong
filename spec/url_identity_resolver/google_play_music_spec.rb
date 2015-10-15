require 'url_identity_resolver/google_play_music'

module UrlIdentityResolver
  RSpec.describe GooglePlayMusic do
    describe '.match?' do
      # artist album track
      [
        'https://play.google.com/music/m/A3wdwq4xf5aqnffdkgnk3ntxxmi?t=Irie_Maffia&h=wAQHGB7L1&s=1',
        'https://play.google.com/music/m/Bgvsd7q6f7jehxagsxoklrpuywm?t=Unknown_album_-_Unknown_artist&h=hAQHrjx7k&s=1',
        'https://play.google.com/music/m/Tbgdeijp7ipltpd3g5y6olqxuzq?t=Utc_ra_Kock_k_-_Irie_Maffia&h=BAQF-IB5P&s=1',
      ].each do |url|
        context "when #{url.inspect}" do
          subject { described_class.match?(url) }
          it { is_expected.to be true }
        end
      end
    end
  end
end
