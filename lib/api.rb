class Api

    @@api_key = "8f1dd76b"

    def self.get_movie_by_id(id)
        url = "https://www.omdbapi.com/?i=#{id}&apikey=#{@@api_key}"
        response = HTTParty.get(url)
        genre_array = response["Genre"].split(", ").collect {|genre_name| Genre.find_by_name(genre_name)}
        stars = response["Actors"].split(", ").collect {|star_name| Star.find_or_create_by_name(star_name)}
        movie_hash = {title: response["Title"], year: response["Year"], runtime: response["Runtime"], genre_array: genre_array, director: response["Director"], stars: stars, plot: response["Plot"], imdbRating: response["imdbRating"]}
        new_movie = Movie.new(movie_hash)
    end

end