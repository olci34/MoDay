class Movie
    
    attr_accessor :title, :year, :runtime, :genre_array, :director, :stars, :plot ,:imdbRating
    @@all = []

    def intialize(title, year, runtime, genre_array, director, stars, plot ,imdbRating)
        self.title = title
        self.year = year
        self.runtime = runtime
        self.genre_array = genre_array
        self.director = director
        self.stars = stars
        self.plot = plot
        self.imdbRating = imdbRating
        self.class.all << self
    end

    def self.all
        @@all
    end

end