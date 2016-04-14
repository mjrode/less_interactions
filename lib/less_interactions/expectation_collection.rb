#TODO ExpectationCollection.new(:name, :age, :weight)
module  Less
  class ExpectationCollection
    attr_reader :parameters
    #TODO parameters will be passed in as a hash {name: "Mike", id: 22}
    #TODO not sure how to implement the allow_nil option here
    #TODO maybe the options hash would look like {name: allow_nil}
    def initialize *parameters
      @parameters = []
      parameters.each do |parameter|
        @parameters << parameter
      end
    end

    def verify(params)
      unless verifies_expectations?(params)
        raise MissingParameterError, "Parameter empty  :#{@parameter}"
      end
    end

    def verifies_expectations?(params)
      @parameters.each do |parameter|
        if params.has_key?(parameter) && all_params_are_not_nil?(params)
          return  true
        else
          return false
        end
      end
    end

  def all_params_are_not_nil?(params)
    params.each do |k,v|
      unless v.nil?
        return true
      end
    end
    false
  end
end

  class MissingParameterError < StandardError; end
end
