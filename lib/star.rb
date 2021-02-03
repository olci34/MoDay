class Star < Person

    @@all = []
    def initialize(name)
        super
        self.class.all << self
    end

    def self.all
        @@all
    end

    def movies
        Movie.all.select {|movie| movie.stars.include?(self.name)}
    end

end