class Star < Person

    @@all = []
    def initialize(name)
        super
        self.class.all << self if !self.class.find_by_name(name) 
    end

    def self.all
        @@all
    end

    def movies
        Movie.all.select {|movie| movie.stars.include?(self.name)}
    end

    def self.find_by_name(name)
        self.all.find {|star| star.name == name}
    end

    def self.create_by_name(name)
        self.new(name)
    end

    def self.find_or_create_by_name(name)
        star = self.find_by_name(name) || self.create_by_name(name)
    end


end