module UrlIdentityResolver
  class Search
    GENERAL_URL_REGEXP = /^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$/i

    def self.match?(url)
      !(url =~ GENERAL_URL_REGEXP)
    end

    def initialize(search_term)
      @search_term = search_term
    end

    def identity
      ProviderIdentity.new(
        provider: 'AppleMusic',
        id: @search_term,
        kind: 'search',
        country_code: 'us',
      )
    end
  end
end
