defmodule FunLand.Semicombinable do
  @moduledoc """
  An operation is Semiombinable if you can combine two values using it, 
  but there is no clearly defined `neutral` thing which you can combine with an element to obtain itself.

  if there _is_ a clearly definable `neutral` element, use `FunLand.Combinable` instead.

  In Category Theory, something that is Semicombinable is called a *Semigroup*.
  """

  @type combinable(_) :: FunLand.adt
  @callback combine(combinable(a), combinable(a)) :: combinable(a) when a: any

  def combine(a, b) do
    do_combine(a, b)
  end

  def do_combine(a = [_|_], b = [_|_]), do: a ++ b
  def do_combine(a = %{}, b = %{}), do: :maps.merge(a, b)

  def do_combine(a = %combinable{}, b = %combinable{}) do
    combinable.combine(a, b)
  end

  def __using__(_opts) do
    quote do
      @behaviour FunLand.Combinable
    end
  end
end
