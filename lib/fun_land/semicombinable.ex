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

  ## In Other Environments

  - In Category Theory, something that is Semicombinable is called a *Semigroup*.


  """

  @type combinable(_) :: FunLand.adt
  @callback combine(combinable(a), combinable(a)) :: combinable(a) when a: any

  # # Lists
  # def combine(a, b) when is_list(a) and is_list(b), do: Kernel.++(a, b)

  # # Binaries
  # def combine(a, b) when is_binary(a) and is_binary(b), do: Kernel.<>(a, b)

  # Behaviour
  def combine(a = %combinable{}, b = %combinable{}) do
    combinable.combine(a, b)
  end

  # builtin data types
  for {guard, module} <- FunLand.Builtin.__builtin__ do
    def combine(combinable_a, combinable_b) when unquote(guard)(combinable_a) and unquote(guard)(combinable_b) do
      apply(unquote(module), :combine, [combinable_a, combinable_b])
    end
  end

  # # Maps
  # def combine(a = %{}, b = %{}) do
  #   :maps.merge(a, b)
  # end

  def __using__(_opts) do
    quote do
      @behaviour FunLand.Combinable
    end
  end
end
