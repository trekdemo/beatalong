module UrlIdentityResolver
  class Null
    # NOOP
    def self.match?(url)
      raise Beatalong::UrlNotSupported
    end
  end
end
