defmodule FunLand.CombinableMonad do
  @moduledoc """
  Things that are both combinable and a monad.

  Useful to build Parser Combinators.


  Known in Haskell as MonadPlus.
  """

  defmacro __using__(_opts) do
    quote location: :keep do 
      use FunLand.Combinable
      use FunLand.Monad

      def guard(predicate)
      def guard(true), do: wrap({})
      def guard(false), do: neutral
    end
  end


  # TODO: How to write guard for lists, etc?
end
