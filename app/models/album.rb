class Album < ApplicationRecord
  has_one_attached :cover
  before_validation :update_slug, :update_cover_url, :update_html

  def self.json
    Album.all.order('created_at').map(&:to_legacy_dict)
  end

  def update_slug
    self.slug = "#{artist} #{title}".parameterize.split('-')[0..3].join('-')
  end

  def update_cover_url
    return unless cover_url.empty?

    self.cover_url = "https://coverartarchive.org/release-group/#{mbid.strip}/front-500"
  end

  def update_cover!
    if cover_url.empty? || cover.attached?
      puts('Cover url is empty or cover was explicitly attached, returning')
      return
    end

    client = HTTPClient.new(default_header: {'User-Agent' => 'BestAlbumsBot 0.1.0/Audiodude <audiodude@gmail.com>'})
    client.ssl_config.clear_cert_store
    client.ssl_config.add_trust_ca('/usr/local/etc/openssl@1.1/cert.pem')
    file = StringIO.new(client.get_content(cover_url))
    self.cover.attach(io: file, filename: "cover#{cover_url[-4]}")
  end

  def update_html
    self.html = Markdown.new(description).to_html unless description.nil?
  end

  def to_legacy_dict
    return {
      artist: artist,
      album: title,
      link: link,
      spotify_id: spotify_id,
      photo_url_sm: cover.url,
      photo_url_lg: cover.url,
      timestamp: created_at.to_time.to_i,
      slug: slug,
      'mini-slug': slug.split('-')[0,4].join('-'),
      html: html,
    }
  end
end
