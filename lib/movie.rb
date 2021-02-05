class Movie

    @@all = []

    def initialize(movie_hash)
        movie_hash.each do |key, value|
            self.class.attr_accessor(key)
            self.send("#{key}=", value)
        end
        self.class.all << self if !self.class.find_by_name(title)
    end

    def self.all
        @@all
    end

    def self.find_by_name(name)
        self.all.find {|movie| movie.title == name}
    end
    
    def self.find_by_imdbID(id)
        Movie.all.find {|movie| movie.imdbID == id}
    end
end