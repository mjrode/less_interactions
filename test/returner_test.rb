require 'test_helper'
class ReturnerTest < Minitest::Test
  include Less

  should "pass if specified objects are not nil" do 
    class InteractionReturning5 < Interaction
      returns :name
      def run; self; end
    end
    int = InteractionReturning5.run(name: "Mike")
    re = Returner.new(:name, allow_nil: false)

    assert_nothing_raised do 
      re.verify!(int)
    end
  end

  should "fail if object is supposed to be returned and it is nil" do 
    class InteractionReturningNil < Interaction
      returns :name
      def run; self; end
    end
    int = InteractionReturningNil.run(age: 33)
    re = Returner.new(:name, allow_nil: false)
     assert_raises NilReturnValueError do 
      re.verify!(int)
     end
  end

  

  should "pass if object returns nil and allow_nil is not specified" do 
    class InteractionReturningNil2 < Interaction
      returns :name
      def run; self; end
    end
    int = InteractionReturningNil2.run()
    re = Returner.new(:name)
    puts "-----------------"
    p re
    assert_nothing_raised do 
      re.verify! int
    end
  end


  # should "fail if all expected objects are not returned" do
  #   re = Returner.new(:name)
  #   params = {name: nil, age: 27}
  #   assert_raises(NilReturnValueError) do
  #     re.verify!(params)
  #   end
  # end

  # should "parameters hash fails if returner is absent" do 
  #   re = Returner.new(:name)
  #   params = {age: 33}
  #   assert_raises(NilReturnValueError) do 
  #     re.verify!(params)
  #   end
  # end
  # should "not fail if allow nil is true and parameters value is nil" do 
  #   re = Returner.new(:name, allow_nil: true)
  #   params = {name: nil}
  #   assert_nothing_raised do 
  #     re.verify!(params)
  #   end
  # end

  # should "not fail if allow nil is true and no parameters are passed" do 
  #   re = Returner.new(:name, allow_nil: true)
  #   params = {}
  #   assert_nothing_raised do 
  #     re.verify!(params)
  #   end
  # end

end
