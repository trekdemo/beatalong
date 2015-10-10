module UrlIdentityResolver
  class Null
    # NOOP
    def initialize(*); end
    def call; end
    def identity; end
  end
end
