defmodule FunLand.Chainable do
  @moduledoc """
  Defines a 'chain' operation to apply a function that takes a simple value and outputs a new Chainable to a value inside a Chainable. 

  Something that is Chainable also needs to be Appliable.

  ## Fruit Salad Example

  There is one problem we haven't covered yet: What if you have an operation that itself returns a bowl?

  Say we have a 'blend' operation, that takes an apple, and returns a bowl with apple juice.

  If we would just `map` 'blend' over a bowl of apples, we would end up putting all the bowls of apple juice inside our original bowl.

  This is clearly not what we want. Instead, we want to pour all of this apple juice back into a single bowl.

  The implementation that tells how to do this, is called `chain`. For bowls, it would be 'put/pour contents of resulting bowl back into original bowl.'


  ## In Other Environments
  - in Haskell, `chain` is known by the name `bind`, or `>>=`.
  
  

  """

  @type chainable(_) :: FunLand.adt
  @callback chain(chainable(a), (a -> b)) :: chainable(b) when a: any, b: any

  defmacro __using__(_opts) do
    quote do
      @behaviour FunLand.Chainable
    end
  end

  def chain(a, b) do
    do_chain(a, b)
  end

  defp do_chain(a = %chainable{}, b) when is_function(b, 1) do
    chainable.chain(a, b)
  end
end
