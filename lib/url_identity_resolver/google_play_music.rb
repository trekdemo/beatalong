module UrlIdentityResolver
  class GooglePlayMusic
    def self.match?(url)
      !!(
        url =~ /^https?:\/\/(play\.)?google\.com/
      )
    end

    def initialize(*); end
    def call; end
    def identity; end
  end
end
