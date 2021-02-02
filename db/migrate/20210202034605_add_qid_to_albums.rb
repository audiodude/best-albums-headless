class AddQidToAlbums < ActiveRecord::Migration[6.1]
  def change
    add_column :albums, :qid, :string
  end
end
