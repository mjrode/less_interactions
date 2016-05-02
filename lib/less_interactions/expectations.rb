# This stores a collection of instances of the expectation class 
# The verify! method calls verify on each individual expectation
# if all expectations are met, then this will return true
# if an expectation is missing, then this will return false

module Less
  class Expectations < Array
    
    def verify!(all_params)
      each do |expectation|
        expectation.verify(all_params)
      end
    end

  end
end


# rename to expectations 