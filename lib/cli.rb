class MoDay

    def greeting
        puts "\n\nWelcome to MoDay! Here is the movie of the day.\n"
        #self.movie_of_the_day Displays a random movie
        self.list_and_pick_genres
    end

    def self.make_genres #Instantiates Genres by using scraped genre names and returns Genres.all array
        genre_names = Scraper.scrape_genre_names
        genre_names.each {|name| Genre.new(name)}
        Genre.all
    end

    def self.make_genre_movies(genre)
        genre_movies = []
        if genre.movies.empty?
            movie_id_array = Scraper.scrape_movie_ids(genre)
            genre_movies = movie_id_array.collect {|id| Api.get_movie_by_id(id)}
        else
            genre_movies = genre.movies
        end
        genre_movies
    end

    def list_and_pick_genres
        Genre.all.empty? ? genres = self.class.make_genres : genres = Genre.all
        input = nil
        while !(1..genres.count).include?(input) #ERROR Handling
            genres.each.with_index(1) {|genre, index| puts "#{index}. #{genre.name}"}
            print "\nPlease pick a genre: "
            input = gets.strip.to_i
        end
        picked_genre = genres[input - 1]
        self.list_genre_movies(picked_genre)
    end

    def list_genre_movies(genre)
        puts "\nHere is #{genre.name} movies of the day."
        movies = self.class.make_genre_movies(genre)
        movies.each.with_index(1) {|movie, index| puts "#{index}. #{movie.title}."}
    end

end