class MoDay

    def greeting
        puts "Welcome to MoDay! Here is the movie of the day."
        #self.movie_of_the_day Displays a random movie
        self.list_and_pick_genres
    end

    def list_and_pick_genres
        genres = ["Action","Drama","Comedy","Documentary"] #TODO: Create Genre class
        input = nil
        while !(1..genres.count).include?(input) #ERROR Handling
            puts "Please pick a genre"
            genres.each.with_index(1) {|genre, index| puts "#{index}. #{genre}"}
            input = gets.strip.to_i
        end
    end

end