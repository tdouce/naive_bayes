# Extend Array class
::Array.class_eval do
    def sum
        self.inject(){|sum, element| sum + element}
    end

    def mean
        self.sum / self.size
    end

    def variance( mean )
        self.inject(0.0) {|sum, element| sum + ( element - mean )**2 } / ( self.size - 1 )
    end
end

