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
        movie_id_array = Scraper.scrape_movie_ids(genre)
        genre_movies = movie_id_array.collect {|id| Api.get_movie_by_id(id)}
        genre.movies
    end

    def list_and_pick_genres
        Genre.all.empty? ? genres = self.class.make_genres : genres = Genre.all  
        options = genres.map {|genre| genre.name}
        picked_genre = Genre.find_by_name(TTY::Prompt.new.select("Please pick a genre:", options))
        self.list_genre_movies(picked_genre)
    end

    def list_genre_movies(genre)
        prompt = TTY::Prompt.new
        puts "\n#{genre.name} menu\n"
        genre.movies.empty? ? movies = self.class.make_genre_movies(genre) : movies = genre.movies
        suggested_movies = movies.sample(3)

        selection = prompt.select("Please pick an option", self.category_options(genre))
        case selection
        when self.category_options(genre)[0]
            puts "Please enter the move star's full name: #{input = gets.strip}"
            self.input_handler(entry: input, genre: genre, object: Star, attribute: "stars")
        when self.category_options(genre)[1]
            puts "Please enter the directors's full name: #{input = gets.strip}"
            self.input_handler(entry: input, genre: genre, object: Director, attribute: "director")
        when self.category_options(genre)[2]
            listed_movie_titles = suggested_movies.map {|movie| movie.title}
            picked_movie = Movie.find_by_name(prompt.select("Pick a movie for more details", listed_movie_titles))
            self.display_movie(picked_movie)
        end
    end

    def input_handler(entry:, genre:, object:, attribute:)
        instance_name = entry.strip.split.map(&:capitalize).join(" ")
        instance = object.find_by_name(instance_name)
        instance_movies = genre.movies.select {|movie| movie.send("#{attribute}").include?(instance)}
        if instance_movies.empty?
            puts "#{instance_name} does not have top rated #{genre.name} movies."
            self.list_genre_movies(genre)
        else 
            movie_titles = instance_movies.map {|movie| movie.title}
            puts "\nHere are the #{instance.name}'s top rated #{genre.name} movies."
            picked_movie_name = TTY::Prompt.new.select("Pick a movie for details:", movie_titles)
            picked_movie = Movie.find_by_name(picked_movie_name)
            self.display_movie(picked_movie)
        end
    end

    def display_movie(movie)
        puts "\n"
        puts "#{movie.title.colorize(:light_blue)} (#{movie.year})"
        puts "Director(s): #{movie.director[0].name}"
        stars_name_list = movie.stars.collect {|star| star.name}
        puts "Movie Stars: #{stars_name_list.join(", ")}\n"
        puts "#{movie.runtime} | imdb Rating: #{movie.imdbRating}\n"
        puts movie.plot
    end

    def category_options(genre)
        options = [
            "Search for your favorite movie star's #{genre.name} movies",
            "Search for your favorite director's #{genre.name} movies",
            "See #{genre.name} movies of the day"
        ]
    end


    def logo
        puts "
        
███╗   ███╗ ██████╗ ██████╗  █████╗ ██╗   ██╗
████╗ ████║██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝
██╔████╔██║██║   ██║██║  ██║███████║ ╚████╔╝ 
██║╚██╔╝██║██║   ██║██║  ██║██╔══██║  ╚██╔╝  
██║ ╚═╝ ██║╚██████╔╝██████╔╝██║  ██║   ██║   
╚═╝     ╚═╝ ╚═════╝ ╚═════╝ ╚═╝  ╚═╝   ╚═╝   
                                             
".colorize(:light_green)
    end
end