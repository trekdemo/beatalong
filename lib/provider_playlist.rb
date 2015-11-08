class ProviderPlaylist
  attr_accessor :title, :author, :cover_image_url, :url, :tracks

  def initialize(attributes)
    attributes.each_pair do |key, value|
      public_send("#{key}=", value)
    end
  end

  def to_s
    [title, author].compact.join(' - ')
  end

  def to_h
    Hash[[:title, :author, :cover_image_url, :url]
      .map {|k| [k, public_send(k)] }]
      .merge(tracks: tracks.map(&:to_h))
  end

  def inspect
    to_h.inspect
  end
end
