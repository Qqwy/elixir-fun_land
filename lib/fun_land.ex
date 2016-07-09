defmodule FunLand do
  # Elixir doesn't let you _really_ define abstract data types.
  @type adt :: [any] | {} | map | struct

  defmacro __using__(_opts) do
    quote do
      import Kernel, except: [<>: 2]

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
    FunLand.Appliable.apply_with(a, b)
  end

  def a ~>> b do
    FunLand.Chainable.chain(a, b)
  end

  # This operator is made more general. It still works for binary combining, as binaries are indeed Combinable.
  def a <> b do
    Funland.Combinable.combine(a, b)
  end
end
