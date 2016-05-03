# Verifies that some conditions are met for a member of a parameters hash
# Class that stores the expectation for the interaction 
# Class is created by passing in what you are expecting to be present when the interaction is called
# the verify method needs all_params as an argument
# all params is what you have passed into the controller
module Less
  class Expectation
    attr_reader :parameter
    attr_accessor :allow_nil
    def initialize parameter, options = {}
      @parameter = parameter
      @allow_nil = options[:allow_nil]
    end

    def verify(all_params)
      unless verifies_expectations?(all_params)
        raise MissingParameterError, "Parameter empty  :#{parameter}"
      end
    end

    private

    def verifies_expectations?(all_params)
      if !allow_nil
        all_params.has_key?(parameter) && all_params[parameter] != nil
      else
        true
      end
    end
  end
  class MissingParameterError < StandardError; end
end


