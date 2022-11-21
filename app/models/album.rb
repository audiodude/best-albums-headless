class Album < ApplicationRecord
  has_one_attached :cover
  before_validation :update_slug, :update_html

  def self.json
    Album.all.order('created_at').map(&:to_legacy_dict)
  end

  def update_slug
    self.slug = "#{artist} #{title}".parameterize.split('-')[0..3].join('-')
  end

  def update_cover!
    return if cover.attached?
    return if mbid.empty?

    cover_url ||= "https://coverartarchive.org/release-group/#{mbid.strip}/front-500"
    puts "cover url is #{cover_url}"

    conn = Faraday.new(url: cover_url, headers: {'User-Agent' => 'BestAlbumsBot 0.1.0/Audiodude <audiodude@gmail.com>'}) do |f|
      f.response :follow_redirects
    end

    file = StringIO.new(conn.get.body)
    self.cover.attach(io: file, filename: "cover#{cover_url[-4]}")
  end

  def update_html
    # This doesn't work, I get quotes escaped in my output
    # markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(escape_html: false, xhtml: false))
    # self.html = markdown.render(description)
    
    # This doesn't work either, sad face.
    # self.html = Markdown.new(description).to_html(render_options = {escape_html: false}) unless description.nil?

    # Just do this for now.
    self.html = description
  end

  def to_legacy_dict
    return {
      artist: artist,
      album: title,
      link: link,
      spotify_id: spotify_id,
      photo_url_sm: cover.variant(resize_to_fit: [90, 80]).processed.url,
      photo_url_lg: cover.url,
      timestamp: created_at.to_time.to_i,
      slug: slug,
      'mini-slug': slug.split('-')[0,4].join('-'),
      html: html,
    }
  end

  def to_gemini
    # Strip known HTML
    self.html.gsub(/<a href="[^"]+">([^<]+)<\/a>/, '\1').gsub(/<\/?(?:p|em|strong)>/, '')
  end
end
