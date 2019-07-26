class Point
    attr_accessor :longitude, :latitude

    def initialize(long, lat)
        @longitude = long
        @latitude = lat
    end

    def mongoize
        return {:type => "Point", :coordinates => [@longitude, @latitude]}
    end

    #returns a Hash
    def self.mongoize(object)
        case object
        when Point then object.mongoize
        when Hash then Point.new(object[:coordinates][0], object[:coordinates][1]).mongoize
        when nil then nil
        end
    end

    #returns a Point
    def self.demongoize(object)
        case object
        when Point then object
        when Hash then Point.new(object[:coordinates][0], object[:coordinates][1])
        when nil then nil
        end
    end

    def self.evolve(object)
        case object
        when Point then object.mongoize
        when Hash then Point.new(object[:coordinates][0], object[:coordinates][1]).mongoize
        when nil then nil
        end
    end
end
