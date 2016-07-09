defmodule FunLand.Monad do
  @moduledoc """
  A Monad is something that is a Monad.
  
  To be a Monad, something has to be Applicative, as well as Chainable.

  Something that is a Monad has four operations:

  - `wrap`, which allows us to put anything inside a new structure of this kind.
  - `map`, which allows us to take a normal function transforming one element, and change it into a function that transforms all of the contents of the structure.
  - `chain`, which allows us to take a function that usually returns a new structure of this kind, and instead apply it on an already-existing structure, the result being a single new structure instead of multiple layers of it.
  - `apply_with`, which allows us to take a partially-applied function _inside_ a structure of this kind to be applied with another structure of this kind.

  This allows us to:

  - Take any normal value and put it into our new structure.
  - Use any normal functions as well as any functions returning a structure of this kind to be used in a sequence of operations.
  - determine what should happen between subsequent operations. (when/how/if the next step should be executed)


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
