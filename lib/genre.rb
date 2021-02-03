class Genre

    attr_accessor :name
    @@all = []

    def initialize(name)
        self.name = name
        self.class.all << self 
    end

    def self.all
        @@all
    end

    def movies
        Movie.all.select do |movie|
            movie.genre_array.split(",").include?(self.name)
        end
    end

end