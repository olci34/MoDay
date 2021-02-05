class Director < Person

    @@all = []
    def initialize(name)
        super
        self.class.all << self if !self.class.find_by_name(name)
    end

    def self.all
        @@all
    end

    def movies
        Movie.all.select {|movie| movie.directors_names.include?(self.name)}
    end

end