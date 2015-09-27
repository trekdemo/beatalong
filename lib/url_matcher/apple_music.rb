module UrlMatcher
  class AppleMusic
    def initialize(url)
      @url = url
    end

    def match?
      @url =~ /https?:\/\/itun\.es/ ||
      @url =~ /https?:\/\/itunes\.apple\.com/
    end
  end
end
