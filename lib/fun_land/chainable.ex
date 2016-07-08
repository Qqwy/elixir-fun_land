defmodule FunLand.Chainable do
  @moduledoc """
  Defines a 'chain' operation to apply a function that takes a simple value and outputs a new Chainable to a value inside a Chainable. 
  """

  @type chainable(_) :: FunLand.adt
  @callback chain(chainable(a), (a -> b)) :: chainable(b) when a: any, b: any

  defmacro __using__(_opts) do
    quote do
      @behaviour FunLand.Chainable
    end
  end

  def chain(a, b) do
    do_chain(a, b)
  end

  defp do_chain(a = %chainable{}, b = %chainable{}) do
    chainable.chain(a, b)
  end
end