# Returner class lets you specify objects you expect to have returned when interaction is run 
# Returner class can verify to make sure the value of these objects is not nil 
# If allow_nil is an option passed to the Returner class then it will return true even if object is nil
module Less
  class Returner
    attr_accessor :parameter
    attr_accessor :allow_nil
    def initialize(parameter, options={allow_nil: true})
      @parameter = parameter
      # Why do we need to check both that the key is present and the value is true
      @allow_nil = options.has_key?(:allow_nil) && options[:allow_nil]
    end

    def verify! interaction
      @interaction = interaction
      unless verifies_expectations?
        raise NilReturnValueError, "Return value is nil for: #{parameter}"
      end
    end

    private

    def verifies_expectations?
      if allow_nil
        true
      else
        # why do we need to call send instead of just calling parameter on the interaction
        @interaction.send(parameter) != nil
      end
    end
  end
  class NilReturnValueError < StandardError; end
end
