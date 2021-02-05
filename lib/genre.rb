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
        Movie.all.select {|movie| movie.genre_array.include?(self)}
    end

    def self.find_by_name(name)
        self.all.find{|genre| genre.name == name}
    end

end