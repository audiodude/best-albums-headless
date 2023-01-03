class AlbumsController < ApplicationController
  before_action :authenticate_user!

  def index
    respond_to {|format|
      format.html { @albums = Album.all.order('created_at DESC') }
      format.json {
        render json: Album.json
      }
    }
  end

  def new
    @album = Album.new
  end

  def create
    @album = Album.new(album_params)
    @album.update_cover!

    if @album.save
      redirect_to albums_path
    else
      render :new
    end
  end

  def show
    @album = Album.find(params[:id])
  end

  def edit
    @album = Album.find(params[:id])
  end

  def update
    @album = Album.find(params[:id])

    @album.update(album_params)
    @album.update_cover!

    if @album.save
      redirect_to album_path(@album)
    end
  end

  def destroy
    @album = Album.find(params[:id])
    @album.destroy

    redirect_to albums_path
  end

  def wikidata
    @album = Album.new
    qid = params[:qid]
    conn = Faraday.new(headers: {'User-Agent' => 'BestAlbumsBot 0.1.0/Audiodude <audiodude@gmail.com>'}) do |f|
      f.response :follow_redirects
      f.response :json
    end

    resp = conn.get("https://www.wikidata.org/wiki/Special:EntityData/#{qid}.json")
    data = resp.body['entities'][qid]

    @album.qid = qid
    @album.title = data.dig('labels', 'en', 'value')
    @album.mbid = data.dig('claims', 'P436', 0, 'mainsnak', 'datavalue', 'value')
    @album.spotify_id = data.dig('claims', 'P2205', 0, 'mainsnak', 'datavalue', 'value')
    artist_qid = data.dig('claims', 'P175', 0, 'mainsnak', 'datavalue', 'value', 'id')
    release_time = data.dig('claims', 'P577', 0, 'mainsnak', 'datavalue', 'value', 'time')
    @album.date = Time.strptime(release_time, '+%Y-%m-%dT%H:%M:%SZ').strftime('%Y-%m-%d')
    @album.link = get_album_link(@album.mbid, data)

    resp = conn.get("https://www.wikidata.org/wiki/Special:EntityData/#{artist_qid}.json")
    artist_data = resp.body['entities'][artist_qid]
    @album.artist = artist_data.dig('labels', 'en', 'value')


    # render json: data
  end

  private

  def get_album_link(mbid, data)
    return "https://musicbrainz.org/release-group/#{mbid}" if mbid

    allmusic_id = data.dig('claims', 'P1729', 0, 'mainsnak', 'datavalue', 'value')
    return "https://www.allmusic.com/album/#{allmusic_id}" if allmusic_id

    amazon_id = data.dig('claims', 'P5749', 0, 'mainsnak', 'datavalue', 'value')
    return "https://www.amazon.com/dp/#{amazon_id}" if amazon_id
  end

  def album_params
    params.require(:album).permit(:title, :artist, :date, :link, :description, :qid, :mbid, :spotify_id, :cover, :cover_url)
  end

  def parse_date(date)
    year, month, day = date.split('T')[0].split('-')
    return year if month == '00'

    if day == '00'
      "#{year}-#{month}"
    else
      "#{year}-#{month}-#{day}"
    end
  end
end
