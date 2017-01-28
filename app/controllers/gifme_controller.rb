class GifmeController < ApplicationController
    def view
       @gif = GifmeHelper.gif params[:word]
       render "index"
    end
end
