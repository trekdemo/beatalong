module UrlIdentityResolver
  class Unsupported
    GENERAL_URL_REGEXP = /^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$/i

    def self.match?(url)
      if url =~ GENERAL_URL_REGEXP
        raise Beatalong::UrlNotSupported
      else
        false
      end
    end
  end
end
