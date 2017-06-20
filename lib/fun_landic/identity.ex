defmodule FunLandic.Identity do
  @moduledoc """
  The Identity ADT is a wrapper around a single element.
  """

  defstruct [:val]
  alias __MODULE__


  use FunLand.Monad

  # Mappable
  def map(%Identity{val: val}, fun) do
    new(fun.(val))
  end

  # Appliable
  def apply_with(%Identity{val: fun}, %Identity{val: val}) do
    new(Currying.curry(fun, val))
  end

  # Applicative
  def new(val) do
    %Identity{val: val}
  end

  # Chainable
  def chain(%Identity{val: val}, fun) do
    fun.(val)
  end



  use FunLand.Reducable

  def reduce(%Identity{val: val}, acc, fun) do
    fun.(val, acc)
  end

  # TODO: Traversable

  # TODO: Comonad




end
