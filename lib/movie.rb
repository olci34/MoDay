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

    def movies
        

end