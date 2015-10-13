module UrlMatcher
  class Spotify
    def self.match?(url)
      !!(
        url =~ /https?:\/\/sptfy\.com/ ||
        url =~ /https?:\/\/play.spotify\.com/
      )
    end
  end
end
