module UrlMatcher
  class Deezer
    def initialize(url)
      @url = url
    end

    def match?
      @url =~ /https?:\/\/(www\.)?deezer\.com/
    end
  end
end
