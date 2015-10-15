module UrlIdentityResolver
  class Null
    # NOOP
    def self.match?(*); true; end
    def initialize(*); end
    def call; end
    def identity; end
  end
end
