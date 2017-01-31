class GifmeController < ApplicationController
    def view
       @gifs = GifmeHelper.gif params[:words]
       render "index"
    end
end
