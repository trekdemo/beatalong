module UrlMatcher
  class Spotify
    def initialize(url)
      @url = url
    end

    def match?
      @url =~ /https?:\/\/sptfy\.com/ ||
      @url =~ /https?:\/\/play.spotify\.com/
    end
  end
end
