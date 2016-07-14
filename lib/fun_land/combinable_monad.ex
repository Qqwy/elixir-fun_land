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

  # Combinable
  defdelegate combine(a, b), to: FunLand.Semicombinable
  defdelegate neutral(module), to: FunLand.Combinable

  # Monad
  defdelegate map(a, fun), to: FunLand.Mappable
  defdelegate apply_with(a, b), to: FunLand.Appliable
  defdelegate wrap(module, a), to: FunLand.Applicative
  defdelegate chain(a, fun), to: FunLand.Chainable

end
