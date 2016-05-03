module Less
  class Interaction
    # Initialize the objects for an interaction.
    # @param [Object] context The context for running an interaction. Optional param.
    # @param [Hash] options   The options are passed when running an interaction. Optional param.
    def initialize(context = {}, options = {})
      #the param context = {} is to allow for interactions with no context
      if context.is_a? Hash
        options.merge! context #context is not a Context so merge it in
      else
        options[:context] = context # add context to the options so will get the ivar and getter
      end

      self.all_params = options
      set_instance_variables
      all_params.each do |name, value|
        # This calls the custom setter if there is one
        if respond_to?( "#{name}=" ) 
          send "#{name}=", value   
        end
      end
    end

    attr_reader :context

    # Definition of the interaction itself. You should override this in your interactions
    #
    # The default implementation raises an {InvalidInteractionError}
    def run
      raise InvalidInteractionError, "You must override the run instance method in #{self.class}"
    end

    def init
    end

    # Run your interaction.
    # @param [Object] context
    # @param [Hash] params
    #
    # This will initialize your interaction with the params you pass to it and then call its {#run} method.
    def self.run(context = {}, params = {})
      me = new(context, params)
      me.send :expectations_met?
      me.init
      out = me.run
      me.send :returners_met?
      out
      
    end

    # Expect certain parameters to be present. If any parameter can't be found, a {MissingParameterError} will be raised.
    # @overload expects(*parameters)
    #   @param *parameters A list of parameters that your interaction expects to find.
    # @overload expects(*parameters, options)
    #   @param *parameters A list of parameters that your interaction expects to find.
    #   @param options A list of options for the exclusion
    #   @option options :allow_nil Allow nil values to be passed to the interaction, only check to see whether the key has been set

    def self.expects(*parameters)
      if parameters.last.is_a?(Hash)
        options = parameters.pop
      else
        options = {}
      end

      parameters.each do |parameter|
        add_reader(parameter)
        add_expectation(parameter, options)
      end
    end

    def self.expects_any(*parameters)
      parameters.each do |parameter|
        add_reader(parameter)
      end
      add_any_expectation(parameters)
    end
    
    # question for eugene - since this is a class method do all methods that are called from it
    # need to be class methods as well 
    # for example add_accessor and add_returner are 
    # parameters are symbols passed to return ex. return :name
    def self.returns(*parameters)
      if parameters.last.is_a?(Hash)
        options = parameters.pop
      else
        options = {allow_nil: true}
      end
      parameters.each do |parameter|
        add_accessor(parameter)
        add_returner(parameter, options)
      end
    end

    private
    
    def all_params
      @__all_params
    end

    def all_params=(p)
      @__all_params = p
    end

    def set_instance_variables
      all_params.each do |name, value|
        instance_variable_set "@#{name}", value
      end

      self.class.expectations.each do |expectation|
        name = expectation.parameter
        if all_params.has_key?(name)
          instance_variable_set "@#{name}", all_params[name]
        elsif expectation.allow_nil
          instance_variable_set "@#{name}", nil
        end
      end
    end

    def self.add_reader param
      methods = (self.instance_methods + self.private_instance_methods)
      self.send(:attr_reader, param) unless methods.member?(param)
    end

    # parameter are symbols being passed in from returns method (ex return :user)
    def self.add_accessor(parameter)
      methods = (self.instance_methods + self.private_instance_methods)
      # checks to make sure another method is not present so it does not 
      # override that method with the attr_accessor
      self.send(:attr_accessor, parameter) unless methods.member?(parameter)
      #p parameter
    end

    def self.add_returner(parameter, options)
      re = Returner.new(parameter, options)
      if returners.none? { |r| r.parameter == parameter}
        returners.push re
      end
    end

    def self.add_expectation(parameter, options)
      ex = Expectation.new(parameter, options)
      if expectations.none? { |e| e.parameter == parameter }
        expectations << ex
      end
    end

    def self.add_any_expectation(parameters)
      new_ex = MultipleChoiceExpectation.new(parameters)
      if any_expectations.none? {|ex| ex.parameters == new_ex.parameters }
        any_expectations << new_ex
      end
    end

    def expectations_met?
      #self.class.any_expectations.met? && self.class.expectations.met?
      self.class.any_expectations.verify!(all_params) && self.class.expectations.verify!(all_params)
    end

    def returners_met?
      self.class.returners.verify! self
    end

    def self.returners
      @returners ||= Returners.new()
    end

    def self.any_expectations
      @any_expectations ||= Expectations.new()
    end

    def self.expectations
      @expectations ||= Expectations.new()
    end
  end


  class InvalidInteractionError < StandardError; end
end
