class Category

    attr_accessor :name
    @@all = []

    def initialize(name)
        self.name = name
        self.class.all << self
    end

    def self.all
        @@all
    end

end