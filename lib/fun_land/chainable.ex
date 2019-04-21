defmodule FunLand.Chainable do
  @moduledoc """
  Defines a 'chain' operation to apply a function that takes a simple value and outputs a new Chainable to a value inside a Chainable.

  Something that is Chainable also needs to be Appliable.

  ## Fruit Salad Example

  There is one problem we haven't covered yet: What if you have an operation that itself returns a bowl?

  Say we have a 'blend' operation, that takes an apple, and returns a bowl with apple juice.

  If we would just `map` 'blend' over a bowl of apples, we would end up putting all the bowls of apple juice inside our original bowl.

  This is clearly not what we want. Instead, we want to combine the results together back into a single bowl.

  The implementation that tells how to do this, is called `chain`. For bowls, it would be 'put/pour contents of resulting bowl back into original bowl and forget about the other bowl.'


  ## In Other Environments
  - in Haskell, `chain` is known by the name `bind`, or `>>=`.


  """

  @type chainable(a) :: FunLand.adt(a)
  @callback chain(chainable(a), (a -> b)) :: chainable(b) when a: any, b: any

  defmacro __using__(_opts) do
    quote do
      @behaviour FunLand.Chainable
    end
  end

  defdelegate map(a, fun), to: FunLand.Mappable
  defdelegate apply_with(a, b), to: FunLand.Appliable
  defdelegate new(module, val), to: FunLand.Applicative

  @doc """
  Chains a function that returns a Chainable at the end of some calculation that returns a Chainable.

  So to `chain` means: Taking the result of an operation that returns a container outside of its container,
  and passing it in to the next function, finally returning the resulting container.
  """
  def chain(chainable, function_that_returns_new_chainable)

  # Stdlib structs
  for {stdlib_module, module} <- FunLand.Builtin.__stdlib_struct_modules__ do
    def chain(a = %unquote(stdlib_module){}, b) do
      apply(unquote(module), :chain, [a, b])
    end
  end

  # Custom structs
  def chain(a = %chainable{}, b) when is_function(b, 1) do
    chainable.chain(a, b)
  end

  # Builtin datatypes
  use FunLand.Helper.GuardMacros
  for {guard, module} <- FunLand.Builtin.__builtin__ do
    def chain(chainable_a, chainable_b) when is_function(chainable_b, 1) and unquote(guard)(chainable_a) do
      apply(unquote(module), :chain, [chainable_a, chainable_b])
    end
  end
end
