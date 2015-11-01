class ProviderIdentity
  VALID_KIND = %w[artist album track playlist search]

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

  def valid?
    !to_a.compact.empty?
  end

  private

  def validated_kind(kind)
    return kind.downcase if VALID_KIND.include?(kind)

    raise kind.strip.empty? ? Beatalong::IdentityNotFound : Beatalong::KindNotSupported.new(kind)
  end
end
