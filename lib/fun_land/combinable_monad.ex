defmodule FunLand.CombinableMonad do
  @moduledoc """
  Things that are both combinable and a monad.

  Useful to build Parser Combinators.


  Known in Haskell as MonadPlus.
  """

  defmacro __using__(_opts) do
    quote do 
      use FunLand.Combinable
      use FunLand.Monad
    end
  end
end