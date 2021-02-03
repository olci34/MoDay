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

    def self.find_by_name(name)
        self.all.find {|director| director.name == name}
    end

    def self.create_by_name(name)
        self.new(name)
    end

    def self.find_or_create_by_name(name)
        director = self.find_by_name(name) || self.create_by_name(name)
    end
end