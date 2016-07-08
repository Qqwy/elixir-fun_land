defmodule FunLand.Applicative do
  @doc """
  Something is Applicative if you can apply one of it (containing a function) to another. 
  
  In Category Theory, something that is Applicative is called an *Apply*. ??
  """
  @type applicative(_) :: FunLand.adt

  # TODO: Best name? `of`, `wrap`?
  @callback of(a) :: applicative(a) when a: any

  defmacro __using__(_opts) do
    quote do
      use FunLand.Appliable
      @behaviour FunLand.Applicative

      @doc "Free implementation of Mappable.map for Applicative"
      def map(a, function) do
        a
        |> of
        |> ap(function)
      end

      defoverridable [map: 2]
    end
  end

  # Note difference of callback and implementation; we need two parameters here.
  def of(module, a) do
    do_of(module, a)
  end

  defp do_of(module, a) do
    module.of(a)
  end

end