module Beatalong
  class UrlNotSupported   < StandardError; end
  class IdentityNotFound  < StandardError; end

  class KindNotSupported < StandardError
    attr_reader :unsupported_kind

    def initialize(unsupported_kind)
      @unsupported_kind = unsupported_kind
    end
  end
end
