class AddHtmlToAlbums < ActiveRecord::Migration[6.1]
  def change
    add_column :albums, :html, :text
  end
end
