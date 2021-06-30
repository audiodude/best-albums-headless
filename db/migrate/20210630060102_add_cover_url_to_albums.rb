class AddCoverUrlToAlbums < ActiveRecord::Migration[6.1]
  def change
    add_column :albums, :cover_url, :string
  end
end
