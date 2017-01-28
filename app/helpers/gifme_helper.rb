module GifmeHelper
    def self.gif(word)
        response = Faraday.get "http://api.giphy.com/v1/gifs/search?q=#{theme}+#{word}&api_key=dc6zaTOxFJmzC"
        response_json = JSON.parse(response.body)
        response_json["data"][0]["images"]["fixed_height"]["url"]
    end

    def self.theme
        ['baby', 'guitar', 'wedding'].sample
    end
end
