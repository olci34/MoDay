class Director < Person

    @@all = []
    def initialize(name)
        super
        self.class.all << self
    end

    def self.all
        @@all
    end

    def movies
        Movie.all.select {|movie| movie.director == self.name}
    end
end