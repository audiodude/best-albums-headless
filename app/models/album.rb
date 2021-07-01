class Album < ApplicationRecord
  has_one_attached :cover
  before_validation :update_slug

  def update_slug
    self.slug = "#{artist} #{title}".parameterize.split('-')[0..3].join('-')
  end

  def update_cover!
    if !self.cover_url.empty?
      client = HTTPClient.new(default_header: {'User-Agent' => 'BestAlbumsBot 0.1.0/Audiodude <audiodude@gmail.com>'})
      file = StringIO.new(client.get_content(cover_url))
      self.cover.attach(io: file, filename: "cover#{cover_url[-4]}")
      return true
    end
    return false
  end
end
