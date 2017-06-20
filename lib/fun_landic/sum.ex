defmodule FunLandic.Sum do
  @moduledoc """
  `Sum` wraps numbers. Each `Sum` struct is a wrapper around a single number, and basically says:
  'I want to treat this number as something that, when combined with another number, should be summed, using `0` as neutral element'

  This is necessary as there are multiple ways to combine numbers. Another, very common way is `FunLandic.Product`.
 
  You can use `Sum` either as a Combinable, by just passing in a Reducable with numbers,

  Or you can use `Sum` as Monad, by wrapping individual numbers and combining them using `map`, `apply_with`, `wrap` and `chain`.
  """
  use FunLand.CombinableMonad

  defstruct [:val]
  alias __MODULE__

  def neutral, do: wrap(0)
  def combine(a = %Sum{val: vala}, b = %Sum{val: valb}), do: wrap(Kernel.+(vala, valb))


  def map(%Sum{val: val}, function) do
    %Sum{val: function.(val) |> assert_value_is_number}
  end

  def apply_with(%Sum{val: fun}, %Sum{val: val}) do
    %Sum{val: fun.(val) |> assert_value_is_number}
  end

  @doc """
  The only things that make sense to put in a %Sum{} are a number,
  or a function that will eventually evaluate to a number.

  Note that unfortunately, Elixir has no way to check the output of a function.
  So we allow 'any' function to be wrapped.
  """
  def wrap(val) when is_number(val) or is_function(val, 1) do
    %Sum{val: val}
  end

  def chain(%Sum{val: val}, function) do
    function.(val)
  end

  defp assert_value_is_number(value) do
    if is_number(value) do
      value
    else
      raise "non-numeric value passed to FunLandic.Sum!"
    end
  end
end
