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
        input = nil
        while !(1..genres.count).include?(input) #ERROR Handling
            genres.each.with_index(1) {|genre, index| puts "#{index}. #{genre.name}"}
            print "\nPlease pick a genre: "
            input = gets.strip.to_i
        end
        self.list_genre_movies(genres[input - 1])
    end

    def list_genre_movies(genre)
        puts "\nHere are the #{genre.name} movies of the day."
        genre.movies.empty? ? movies = self.class.make_genre_movies(genre) : movies = genre.movies
        listed_movies = movies.sample(3)
        listed_movies.each.with_index(1) {|movie, index| puts "#{index}. #{movie.title}."}
        input = ""
        while !(1..3).include?(input.to_i) && !input.start_with?("starring","directedby") # ERROR Handling
            puts "\nEnter the number of the movie for more details."
            puts "Look for #{genre.name} movies of your favorite movie star by using \"starring\" followed by the movie star's full name."
            puts "Look for #{genre.name} movies of your favorite director by using \"directedby\" followed by the director's full name."
            input = gets.strip.downcase
        end

        if input.start_with?("starring")
            self.input_handler(entry: input, genre: genre, object: Star, attribute: "stars")
        elsif input.start_with?("directedby")
            self.input_handler(entry: input, genre: genre, object: Director, attribute: "director")
        else
            self.display_movie(listed_movies[input.to_i - 1])
        end
    end

    def input_handler(entry:, genre:, object:, attribute:)
        instance_name = entry.split(" ",2)[1].strip.split.map(&:capitalize).join(" ")
        instance = object.find_by_name(instance_name)
        instance_movies = genre.movies.select {|movie| movie.send("#{attribute}").include?(instance)}
        if instance_movies.empty?
            puts "#{instance_name} does not have top rated #{genre.name} movies."
            self.list_genre_movies(genre)
        else 
            puts "\nHere are the #{instance.name}'s top rated #{genre.name} movies."
            instance_movies.each.with_index(1) {|movie, index| puts "#{index}. #{movie.title}"}
            input = ""
            while !(1..instance_movies.count).include?(input)
                print "\nEnter the number of the movie for more details: "
                input = gets.strip.to_i
            end
            self.display_movie(instance_movies[input - 1])
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