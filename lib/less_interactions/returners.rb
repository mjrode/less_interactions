# Collection of Returner classes 
# The verify method calls verify on each individual returner instance 
# If all expected return values are not nil then the Returners class returns true
# If expected return value is nil then Returner class raises NilReturnValueError 
module Less
  class Returners < Array
    
    def verify! interaction
      each do |returner|
        returner.verify!(interaction)
      end
    end

  end
end
