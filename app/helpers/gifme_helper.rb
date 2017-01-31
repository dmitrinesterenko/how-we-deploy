module GifmeHelper
    def self.gif(sentence)
        words = sentence.split(' ')
        responses = []
        words.each do |word|
            response = Faraday.get "http://api.giphy.com/v1/gifs/search?q=#{word}&api_key=dc6zaTOxFJmzC"
            response_json = JSON.parse(response.body)
            responses.push(response_json["data"][0]["images"]["fixed_height"]["url"])
        end
        responses
    end

end
