class AddHtmlToAlbums < ActiveRecord::Migration[6.1]
  def change
    add_column :albums, :html, :string
  end
end
