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
        puts "\nHere is #{genre.name} movies of the day."
        genre.movies.empty? ? movies = self.class.make_genre_movies(genre) : movies = genre.movies  
        movies.sample(3).each.with_index(1) {|movie, index| puts "#{index}. #{movie.title}."}
        input = ""
        while !(1..3).include?(input.to_i) && !input.start_with?("starring","directedby") # ERROR Handling
            puts "Enter the number of the movie for more details."
            puts "Look for #{genre.name} movies of your favorite movie star by using \"starring\" followed by the movie star's full name."
            puts "Look for #{genre.name} movies of your favorite director by using \"directedby\" followed by the director's full name."
            input = gets.strip.downcase
        end
        if input.start_with?("starring")
            star_name = input.split(" ",2)[1].strip.split.map(&:capitalize).join(" ") 
            star_movies = movies.select {|movie| movie.stars.include?(Star.find_by_name(star_name))} #TODO: create #find_by_name method in Stars. 
            if star_movies.empty?
                 puts "#{star_name} does not have top rated #{genre.name} movies."
                 self.list_genre_movies(genre)
            else 
                star_movies.each {|movie| puts movie.title}
            end
        elsif input.start_with?("directedby")
            director_name = input.split(" ",2)[1].strip.split.map(&:capitalize).join(" ")
            director_movies = movies.select {|movie| movie.director.include?(Director.find_by_name(director_name))}
            if director_movies.empty?
                 puts "#{director_name} does not have top rated #{genre.name} movies."
                 self.list_genre_movies(genre)
            else 
                director_movies.each {|movie| puts movie.title}
            end
        end
    end

end