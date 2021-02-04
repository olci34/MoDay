class Movie

    @@all = []

    def initialize(movie_hash)
        movie_hash.each do |key, value|
            self.class.attr_accessor(key)
            self.send("#{key}=", value)
        end
        self.class.all << self
    end

    def self.all
        @@all
    end

    def self.find_by_name(name)
        self.all.find {|movie| movie.title == name}
    end

end