class Album < ApplicationRecord
  has_one_attached :cover
  before_validation :update_slug, :update_cover_url, :update_html

  def update_slug
    self.slug = "#{artist} #{title}".parameterize.split('-')[0..3].join('-')
  end

  def update_cover_url
    return unless cover_url.empty?

    puts 'Updating cover url'
    self.cover_url = "http://coverartarchive.org/release-group/#{mbid.strip}/front-500"
  end

  def update_cover!
    return if cover_url.empty? || cover.attached?

    client = HTTPClient.new(default_header: {'User-Agent' => 'BestAlbumsBot 0.1.0/Audiodude <audiodude@gmail.com>'})
    file = StringIO.new(client.get_content(cover_url))
    self.cover.attach(io: file, filename: "cover#{cover_url[-4]}")
  end
end
