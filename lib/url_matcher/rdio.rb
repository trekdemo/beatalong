module UrlMatcher
  class Rdio
    def self.match?(url)
      !!(
        url =~ /https?:\/\/(www\.)?rdio\.com/ ||
        url =~ /https?:\/\/(www\.)?rd\.io/
      )
    end
  end
end
