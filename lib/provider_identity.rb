class ProviderIdentity
  attr_reader :provider, :id, :kind
  def initialize(provider:, id:, kind:)
    @provider = provider
    @id = id
    @kind = kind
  end

  def to_a
    [provider, id, kind]
  end

  def ==(other)
    to_a == other.to_a
  end
end
