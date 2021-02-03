class Star < Person

    @@all = []
    def initialize(name)
        super
        self.class.all << self
    end

    def self.all
        @@all
    end

end