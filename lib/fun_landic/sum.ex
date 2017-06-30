defmodule FunLandic.Sum do
  @moduledoc """
  `Sum` wraps numbers. Each `Sum` struct is a wrapper around a single number, and basically says:
  'I want to treat this number as something that, when combined with another number, should be summed, using `0` as empty element'

  This is necessary as there are multiple ways to combine numbers. Another, very common way is `FunLandic.Product`.

  You can use `Sum` either as a Combinable, by just passing in a Reducable with numbers,

  Or you can use `Sum` as Monad, by wrapping individual numbers and combining them using `map`, `apply_with`, `wrap` and `chain`.
  """
  use FunLand.CombinableMonad

  defstruct [:val]
  alias __MODULE__

  def empty, do: new(0)
  def combine(a = %Sum{val: vala}, b = %Sum{val: valb}), do: new(Numbers.add(vala, valb))

  def map(%Sum{val: val}, function) do
    new(function.(val))
  end

  def apply_with(%Sum{val: fun}, %Sum{val: val}) do
    new(fun.(val))
  end

  def new(val) do
    %Sum{val: val}
  end

  def chain(%Sum{val: val}, function) do
    function.(val)
  end
end
