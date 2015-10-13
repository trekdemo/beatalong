module UrlMatcher
  class AppleMusic
    def self.match?(url)
      !!(
        url =~ /https?:\/\/itun\.es/ ||
        url =~ /https?:\/\/itunes\.apple\.com/
      )
    end
  end
end
