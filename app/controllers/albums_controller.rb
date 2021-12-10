class AlbumsController < ApplicationController
  before_action :authenticate_user!

  def index
    @albums = Album.all
    respond_to {|format|
      format.html
      format.json {
        render json: @albums.map {|a| a.to_legacy_dict }
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

  def search
    query = request.query_parameters['q']
    client = HTTPClient.new default_header: {'User-Agent' => 'BestAlbumsBot 0.1.0/Audiodude <audiodude@gmail.com>'}

    content = client.get_content(
      'https://www.wikidata.org/w/api.php',
      action: 'wbsearchentities',
      search: query, language: 'en', format: 'json'
    )
    results = JSON.parse(content)
    raise StandardError, 'Error from external endpoint' if results['success'] != 1

    ids = results['search'].map { |r| "wd:#{r['id']}" }.join(' ')

    if ids.empty?
      render json: []
      return
    end

    sparql = <<-SPARQL
      SELECT ?a ?aLabel ?r ?rLabel ?mbid ?spid ?date WHERE {
        VALUES ?a { #{ids} }
        ?a wdt:P31/wdt:P279* wd:Q482994 ;
           wdt:P175 ?r .
        OPTIONAL {
          ?a wdt:P436 ?mbid .
        }
        OPTIONAL {
          ?a wdt:P2205 ?spid .
        }
        OPTIONAL {
          ?a wdt:P577 ?date
        }
        SERVICE wikibase:label {
          bd:serviceParam wikibase:language "en" .
        }
      }
    SPARQL

    res = client.post('https://query.wikidata.org/sparql', query: sparql, format: 'json')
    data = JSON.parse(res.body)
    albums = {}

    data['results']['bindings'].each do |b|
      id_ = b['a']['value'].split('/')[-1]
      next if albums.key?(id_)

      a = {
        id: id_,
        title: b['aLabel']['value'],
        artist: b['rLabel']['value'],
        date: b['date'] && parse_date(b['date']['value']),
        mbid: b['mbid'] && b['mbid']['value'],
        spid: b['spid'] && b['spid']['value']
      }
      albums[id_] = a
    end

    render json: albums.values
  end

  private

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
