module UrlMatcher
  class Deezer
    def self.match?(url)
      !!(
        url =~ /^https?:\/\/(www\.)?deezer\.com\/(artist|album|track)/
      )
    end
  end
end
