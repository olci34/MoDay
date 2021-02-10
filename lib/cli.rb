class MoDay

    def initialize
        @pastel = Pastel.new
        @prompt = TTY::Prompt.new
        @data_source = {} # every element's key is a Genre and value Movie array
        @current_genre = ""
    end

    def greeting
        puts "\n\nWelcome to MoDay!"
        self.list_and_pick_genres
    end

    def make_genres # Scrapes genre names and instantiates new Genres
        genre_names = Scraper.scrape_genre_names
        genre_names.each {|name| Genre.new(name)}
        Genre.all
    end

    def make_genre_movies(genre) # Avoids scraping the passed genre page by storing movie ids, makes new Movies from stored movie ids
        stored_ids = @data_source[genre].collect {|m| m.imdbID} if @data_source[genre]
        movie_id_array = stored_ids || Scraper.scrape_movie_ids(genre) #Avoids scraping same page
        bar = TTY::ProgressBar.new("#{genre.name} genre content is loading[:bar]", total: movie_id_array.count / 2)
        genre_movies = movie_id_array.collect do |id|
            bar.advance
            Api.get_movie_by_id(id)
        end
        if genre_movies.find {|x| x == nil}
            prompt.warn("Something went wrong")
        else
        @data_source[genre] = genre_movies if !stored_ids # Stores scraped data if it hasn't stored before
        genre.movies 
        end
    end

    def list_and_pick_genres # Finds already existed genre list or makes a new Genre list
        Genre.all.empty? ? genres = self.make_genres : genres = Genre.all  
        options = genres.map {|genre| genre.name}
        picked_genre = Genre.find_by_name(@prompt.select(@pastel.cyan("\nPlease pick a genre:"), options))
        puts "\n"
        @current_genre = picked_genre # Assigns current_genre variable to picked genre in order to use it as an argument for needed methods.(Had to keep track because of <Back button.)
        self.genre_menu(picked_genre)
    end

    def genre_menu(genre) # Lists selected genre menu options
        self.make_genre_movies(genre)
        selection = @prompt.select(@pastel.yellow("\n#{genre.name} Menu"), self.genre_menu_options(genre))
        self.genre_menu_handler(selection: selection, genre: genre)
    end

    def genre_menu_handler(selection:, genre:)
        menu = self.genre_menu_options(genre)
        case selection
        when menu[0]
            self.input_handler(genre: genre, object: Star, attribute: "stars")
        when menu[1]
            self.input_handler(genre: genre, object: Director, attribute: "director")
        when menu[2]
            self.suggest_genre_movies(genre)
        when menu[3]
            self.list_and_pick_genres
        when menu[4]
            abort("Bye fam")
        end
    end

    def input_handler(genre:, object:, attribute:)
        print @pastel.cyan("Please enter the movie #{object.name.downcase}'s full name: ")
        instance_name = gets.strip.split.map(&:capitalize).join(" ")
        instance = object.find_by_name(instance_name)
        instance_movies = genre.movies.select {|movie| movie.send("#{attribute}").include?(instance)}
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
        puts "#{@pastel.green.dark("Director(s)")}: #{movie.directors_names}"
        puts "#{@pastel.green.dark("Movie Stars:")} #{movie.stars_name}\n"
        puts "#{@pastel.green.dark("Runtime:")} #{movie.runtime}"
        puts "#{@pastel.green.dark("Imdb Rating:")} #{movie.imdbRating}\n"
        puts "#{@pastel.green.dark("Plot:")} #{movie.plot}"
        choices = ["#{@pastel.bright_red("<Back")}", "#{@pastel.bright_green.bold("Watch>")}"]
        selection = @prompt.select("\n", choices)
        selection == choices[0] ? self.page_navigation : abort("Good pick fam!")
    end

    def page_navigation(picked_item = nil, genre = @current_genre)
        !picked_item ? self.genre_menu(genre) : self.display_movie(picked_item)
    end

    def suggest_genre_movies(genre)
        suggested_movies = @data_source[genre].sample(3)
        listed_movie_titles = suggested_movies.map {|movie| movie.title} << ["#{@pastel.bright_red("<Back")}", "#{@pastel.bright_yellow("Exit.")}"]
        selection = @prompt.select(@pastel.cyan("Pick a movie for more details"), listed_movie_titles)
        picked_movie = Movie.find_by_name(selection)
        if selection || selection == listed_movie_titles[-2]
            self.page_navigation(picked_movie, genre)
        else
            abort("Bye fam")
        end
    end

    def genre_menu_options(genre)
        options = [
            "Search for your favorite movie star's #{genre.name} movies",
            "Search for your favorite director's #{genre.name} movies",
            "See #{genre.name} movies of the day",
            "#{@pastel.bright_red("<Back")}",
            "#{@pastel.bright_yellow("Exit.")}"
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