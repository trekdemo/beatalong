class ProviderEntity
  attr_accessor :artist, :album, :title, :cover_image_url, :url, :kind, :original

  def initialize(attributes)
    attributes.each_pair do |key, value|
      public_send("#{key}=", value)
    end
  end

  def to_h
    Hash[[:artist, :album, :title, :cover_image_url, :url, :kind, :original].map {|k| [k, public_send(k)] }]
  end

  def inspect
    to_h.inspect
  end
end
