defmodule FunLand do
  # Elixir doesn't let you _really_ define abstract data types.
  @type adt :: [] | {} | %{} | struct

  defmacro __using__(_opts) do
    quote do
      alias FunLand.{
        Mappable,
        Appliable,
        Applicative,
        Chainable,
        Monad,

        SemiCombinable,
        Combinable,

        Reducable,
        Traversable
      }
      import FunLand
    end
  end


  def a ~> b do
    FunLand.Mappable.map(a, b)
  end

  def a <~> b do
    FunLand.Appliable.apply(a, b)
  end

  def a ~>> b do
    FunLand.Chainable.chain(a, b)
  end
end
