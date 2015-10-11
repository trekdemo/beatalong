class ProviderIdentity
  VALID_KIND = %w[artist album track playlist]

  attr_reader :provider, :id, :kind, :country_code

  def initialize(provider:, id:, kind:, country_code:)
    @provider = provider
    @id = id
    @kind = validated_kind(kind.to_s)
    @country_code = country_code
  end

  def to_a
    [provider, id, kind]
  end

  def ==(other)
    to_a == other.to_a
  end

  def validated_kind(kind)
    return kind if VALID_KIND.include?(kind)

    fail ArgumentError, "#{kind.inspect} is not a valid kind!"
  end
end
