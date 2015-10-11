class ProviderIdentity
  attr_reader :provider, :id, :kind, :country_code
  def initialize(provider:, id:, kind:, country_code:)
    @provider = provider
    @id = id
    @kind = kind
    @country_code = country_code
  end

  def to_a
    [provider, id, kind]
  end

  def ==(other)
    to_a == other.to_a
  end
end
