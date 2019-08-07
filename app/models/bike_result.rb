class BikeResult < LegResult

    field :mph, type: Float

    def calc_ave
        if event && secs
            miles = event.miles
            self.mph=miles.nil? ? nil : (miles/(secs/3600)).round(2)
        end
    end
end