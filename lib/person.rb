class Person

    extend Concerns::Findable

    attr_accessor :name
    def initialize(name)
        self.name = name
    end
    
end