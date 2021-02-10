class Api

    @@api_key = "8f1dd76b"

    def self.get_movie_by_id(id)
        movie = Movie.find_by_imdbID(id)
        if !movie #Avoids requesting API on already existed movies.
            url = "https://www.omdbapi.com/?i=#{id}&apikey=#{@@api_key}j"
            response = HTTParty.get(url)
            if response["Error"]    # API ERROR HANDLING
                abort("Something went wrong: #{response["Error"]}")
            else
            genre_array = response["Genre"].split(", ").collect {|genre_name| Genre.find_by_name(genre_name)}
            stars = response["Actors"].split(", ").collect {|star_name| Star.find_or_create_by_name(star_name)}
            director = response["Director"].split(", ").collect {|star_name| Director.find_or_create_by_name(star_name)}
            movie_hash = {title: response["Title"], year: response["Year"], runtime: response["Runtime"], genre_array: genre_array, director: director, stars: stars, plot: response["Plot"], imdbRating: response["imdbRating"], imdbID: response["imdbID"]}
            new_movie = Movie.new(movie_hash)
            end
        else
            movie
        end
    end

end