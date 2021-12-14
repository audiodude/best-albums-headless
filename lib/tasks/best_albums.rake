namespace :best_albums do
  desc 'Import albums from an albums.json file generated by the legacy BAITU app'
  task import: :environment do
    # albums.json should be in the tasks directory
    json = File.open('albums_legacy.json').read
    data = JSON.parse(json)
    data['albums'].each { |legacy|
      legacy['title'] = legacy['album']
      puts("Processing #{legacy['title']}")
      legacy.delete('album')

      legacy['cover_url'] = legacy['photo_url_lg']
      legacy.delete('photo_url_lg')
      legacy.delete('photo_url_sm')

      legacy['created_at'] = DateTime.strptime(legacy['timestamp'].to_s,'%s')
      legacy.delete('timestamp')

      legacy.delete('slug')
      legacy.delete('mini-slug')

      album = Album.new(legacy)
      album.update_cover!
      album.save!
    }
  end

  desc 'Generate the albums.json file and place it in _site'
  task build: :environment do

  end
end