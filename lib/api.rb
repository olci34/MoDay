class Api

    @@api_key = "8f1dd76b"

    def self.get_movie_by_id(id)
        url = "https://www.omdbapi.com/?i=#{id}&apikey=#{@@api_key}"
        response = HTTParty.get(url)
        movie_hash = {title: response["Title"], year: response["Year"], runtime: response["Runtime"]. genre_array: response["Genre"], director: response["Director"], stars: response["Actors"], plot: response["Plot"], imdbRating: response["imdbRating"]}
    end

end