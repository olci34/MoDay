module Concerns

    module Findable

        def find_by_name(name)
            self.all.find {|x| x.name == name}
        end

        def create_by_name(name)
            self.new(name)
        end

        def find_or_create_by_name(name)
            x = self.find_by_name(name) || self.create_by_name(name)
        end

    end

end