module UrlMatcher
  class Rdio
    def initialize(url)
      @url = url
    end

    def match?
      @url =~ /https?:\/\/(www\.)?rdio\.com/ ||
      @url =~ /https?:\/\/(www\.)?rd\.io/
    end
  end
end
