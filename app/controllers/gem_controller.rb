class GemController < ApplicationController

  def index
    @albums = Album.all
  end

  def album
    @album = Album.where(slug: params[:slug]).first
  end
end