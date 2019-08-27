class Address
    attr_accessor :city, :state, :location

    def initialize(city=nil, state=nil, location=nil)
        @city = city
        @state = state
        @location = location.is_a?(Point) ? location : Point.demongoize(location)
    end

    def mongoize 
          puts "location = #{Point.mongoize(@location)}"
        return{:city => @city, :state => @state, :loc => (Point.mongoize(@location))}
    end

    #returns a Hash
    def self.mongoize(object)
        case object
        when Address then object.mongoize
        when Hash then Address.new(object[:city], object[:state], object[:loc]).mongoize
        when nil then nil
        end
    end

    #returns an Address
    def self.demongoize(object)
        case object
        when Address then object
        when Hash then Address.new(object[:city], object[:state], object[:loc])
        when nil then nil
        end
    end

    def self.evolve(object)
        case object
        when Address then object.mongoize
        when Hash then Address.new(object[:city], object[:state], object[:loc]).mongoize
        when nil then nil
        end
    end
end