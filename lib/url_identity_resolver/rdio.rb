module UrlIdentityResolver
  class Rdio
    def self.match?(url)
      !!(
        url =~ /https?:\/\/(www\.)?rdio\.com/ ||
        url =~ /https?:\/\/(www\.)?rd\.io/
      )
    end

    def initialize(*); end
    def call; end
    def identity; end
  end
end
