defmodule FunLand.Traversable do

  @type traversable(_) :: FunLand.adt

  @callback sequence(traversable(a), (a -> FunLand.Applicative.applicative(b))) :: FunLand.Applicative.applicative(traversable(b)) when a: any, b: any

  defmacro __using__(_opts) do
    quote do
      use FunLand.Mappable
      use FunLand.Reducable
    end
  end
end
