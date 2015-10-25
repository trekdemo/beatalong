module Beatalong
  class UrlNotSupported   < StandardError; end
  class IdentityNotFound  < StandardError; end

  class KindNotSupported < StandardError
    attr_reader :unsupported_kind

    def initialize(unsupported_kind)
      @unsupported_kind = unsupported_kind
    end
  end

  class ShortUrlError < StandardError
    attr_reader :long_url

    def initialize(long_url)
      @long_url = long_url
    end
  end
end
