class MoDay

    def initialize
        @pastel = Pastel.new
        @prompt = TTY::Prompt.new
        @data_source = {}
        @current_genre = ""
    end

    def greeting
        puts "\n\nWelcome to MoDay!"
        self.list_and_pick_genres
    end

    def make_genres #Instantiates Genres by using scraped genre names and returns Genres.all array
        genre_names = Scraper.scrape_genre_names
        genre_names.each {|name| Genre.new(name)}
        Genre.all
    end

    def make_genre_movies(genre)
        movie_id_array = []
        if @data_source[genre.name]
            movie_id_array = @data_source[genre.name]
        else
            movie_id_array = Scraper.scrape_movie_ids(genre)
            @data_source[genre.name] = movie_id_array
        end
        bar = TTY::ProgressBar.new("#{genre.name} genre content is loading[:bar]", total: movie_id_array.count / 2)
        genre_movies = movie_id_array.collect do |id|
            Api.get_movie_by_id(id)
            bar.advance
        end
        genre.movies
    end

    def list_and_pick_genres
        Genre.all.empty? ? genres = self.make_genres : genres = Genre.all  
        options = genres.map {|genre| genre.name}
        picked_genre = Genre.find_by_name(@prompt.select(@pastel.cyan("\nPlease pick a genre:"), options))
        puts "\n"
        @current_genre = picked_genre
        self.genre_menu(picked_genre)
    end

    def genre_menu(genre)
        fetched_movies = self.make_genre_movies(genre)
        selection = @prompt.select(@pastel.yellow("\n#{genre.name} Menu"), self.genre_menu_options(genre))
        self.genre_menu_handler(selection: selection, genre: genre, fetched_movies: fetched_movies)
    end

    def genre_menu_handler(selection:, genre:, fetched_movies:)
        menu = self.genre_menu_options(genre)
        case selection
        when menu[0]
            self.input_handler(genre: genre, object: Star, attribute: "stars")
        when menu[1]
            self.input_handler(genre: genre, object: Director, attribute: "director")
        when menu[2]
            self.suggest_genre_movies(genre, fetched_movies)
        when menu[3]
            self.list_and_pick_genres
        end
    end

    def input_handler(genre:, object:, attribute:)
        print @pastel.cyan("Please enter the movie #{object.name.downcase}'s full name: ")
        instance_name = gets.strip.split.map(&:capitalize).join(" ")
        instance = object.find_by_name(instance_name)
        instance_movies = genre.movies.select {|movie| movie.send("#{attribute}").include?(instance)} #TODO: create find_person_movies method in Genre
        if instance_movies.empty?
            puts @pastel.red.italic("\n#{instance_name} does not have top rated #{genre.name} movies.")
            self.page_navigation
        else 
           self.list_person_movies(genre, instance_movies, instance)
        end
    end

    def list_person_movies(genre,movies,instance)
        movie_titles = movies.map {|movie| movie.title} << "#{@pastel.bright_red("<Back")}"
        puts "\nHere are the #{instance.name}'s top rated #{genre.name} movies."
        picked_movie_name = @prompt.select(@pastel.cyan("Pick a movie for details:"), movie_titles)
        picked_movie = Movie.find_by_name(picked_movie_name)
        self.page_navigation(picked_movie, genre)
    end

    def display_movie(movie)
        puts "\n"
        puts "#{@pastel.green.bold(movie.title)} (#{movie.year})"
        puts "#{@pastel.green.dark("Director(s)")}: #{movie.director[0].name}"
        stars_name_list = movie.stars.collect {|star| star.name}
        puts "#{@pastel.green.dark("Movie Stars:")} #{stars_name_list.join(", ")}\n"
        puts "#{@pastel.green.dark("Runtime:")} #{movie.runtime}"
        puts "#{@pastel.green.dark("Imdb Rating:")} #{movie.imdbRating}\n"
        puts "#{@pastel.green.dark("Plot:")} #{movie.plot}"
        choices = ["#{@pastel.bright_red("<Back")}", "#{@pastel.bright_green.bold("Watch>")}"]
        selection = @prompt.select("\n", choices)
        selection == choices[0] ? self.page_navigation : exit
    end

    def page_navigation(picked_item = nil, genre = @current_genre)
        !picked_item ? self.genre_menu(genre) : self.display_movie(picked_item)
    end

    def suggest_genre_movies(genre, fetched_movies)
        suggested_movies = fetched_movies.sample(3)
        listed_movie_titles = suggested_movies.map {|movie| movie.title} << "#{@pastel.bright_red("<Back")}" 
        picked_movie = Movie.find_by_name(@prompt.select(@pastel.cyan("Pick a movie for more details"), listed_movie_titles))
        self.page_navigation(picked_movie, genre)
    end

    def genre_menu_options(genre)
        options = [
            "Search for your favorite movie star's #{genre.name} movies",
            "Search for your favorite director's #{genre.name} movies",
            "See #{genre.name} movies of the day",
            "#{@pastel.bright_red("<Back")}"
        ]
    end

    def logo
        puts Pastel.new.green("
        
███╗   ███╗ ██████╗ ██████╗  █████╗ ██╗   ██╗
████╗ ████║██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝
██╔████╔██║██║   ██║██║  ██║███████║ ╚████╔╝ 
██║╚██╔╝██║██║   ██║██║  ██║██╔══██║  ╚██╔╝  
██║ ╚═╝ ██║╚██████╔╝██████╔╝██║  ██║   ██║   
╚═╝     ╚═╝ ╚═════╝ ╚═════╝ ╚═╝  ╚═╝   ╚═╝   
                                             
")
    end
end