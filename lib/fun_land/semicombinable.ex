defmodule FunLand.Semicombinable do
  @moduledoc """
  An operation is Semiombinable if you can combine two values using it,
  but there is no clearly defined `neutral` thing which you can combine with an element to obtain itself.

  if there _is_ a clearly definable `neutral` element, use `FunLand.Combinable` instead.


  ## Fruit Salad Example

  If you have one bowl with apples, and a second bowl with oranges, one can combine these, by putting the apples and the oranges in the same bowl.

  This follows the Semicombinable law:

  - associativity: `combine(combine(bowl_with_apples, bowl_with_oranges), bowl_with_bananas)` results in the same bowl as `combine(bowl_with_apples, combine(bowl_with_oranges, bowl_with_bananas))


  ## Some Common Semigroups

  - Strings (binaries)
  - List Concatenation
  - Algebraic Addition
  - Algebraic Multiplication

  Many semicombinables are not only 'semi', but fully Combinable. (See the `Combinable` module)

  ## In Other Environments

  - In Category Theory, something that is Semicombinable is called a *Semigroup*.


  """

  @type combinable(a) :: FunLand.adt(a)
  @callback combine(combinable(a), combinable(a)) :: combinable(a) when a: any

  def __using__(_opts) do
    quote do
      @behaviour FunLand.Combinable
    end
  end

  # stdlib structs
  for {stdlib_module, module} <- FunLand.Builtin.__stdlib_struct_modules__ do
    def combine(a = %unquote(stdlib_module){}, b = %unquote(stdlib_module){}) do
      apply(unquote(module), :combine, [a, b])
    end
  end

  # custom structs
  def combine(a = %combinable{}, b = %combinable{}) do
    combinable.combine(a, b)
  end

  # builtin data types
  use FunLand.Helper.GuardMacros
  for {guard, module} <- FunLand.Builtin.__builtin__ do
    def combine(combinable_a, combinable_b) when unquote(guard)(combinable_a) and unquote(guard)(combinable_b) do
      apply(unquote(module), :combine, [combinable_a, combinable_b])
    end
  end

end
