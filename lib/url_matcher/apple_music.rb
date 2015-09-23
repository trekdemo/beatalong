module UrlMatcher
  class AppleMusic
    def initialize(url)
      @url = url
    end

    def match?
      @url =~ /itun\.es/
    end
  end
end
