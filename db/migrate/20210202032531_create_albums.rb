class CreateAlbums < ActiveRecord::Migration[6.0]
  def change
    create_table :albums do |t|
      t.string :title
      t.string :artist
      t.date :date
      t.string :link
      t.string :slug
      t.text :description

      t.timestamps

      t.string :mbid
      t.string :spotify_id
    end
  end
end