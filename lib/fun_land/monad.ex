defmodule FunLand.Monad do
  @moduledoc """
  A Monad is something that is a Monad.
  
  To be a Monad, something has to be Applicative, as well as Chainable.
  """

  defmacro __using__(_opts) do
    quote do
      use FunLand.Applicative
      @behaviour FunLand.Chainable

    end
  end


  defdelegate ap(a, b), to: FunLand.Appliable
  defdelegate of(module, a), to: FunLand.Applicative
  defdelegate chain(a, b), to: FunLand.Chainable

end
