defmodule FunLandic.Product do
  @moduledoc """
  `Product` wraps numbers. Each `Product` struct is a wrapper around a single number, and basically says:
  'I want to treat this number as something that, when combined with another number, should be multiplied, using `1` as neutral element'

  This is necessary as there are multiple ways to combine numbers. Another, very common way is `FunLandic.Sum`.

  You can use `Product` either as a Combinable, by just passing in a Reducable with numbers,

  Or you can use `Product` as Monad, by wrapping individual numbers and combining them using `map`, `apply_with`, `wrap` and `chain`.
  """
  use FunLand.CombinableMonad

  defstruct [:val]
  alias __MODULE__

  def neutral, do: 1
  def combine(a, b), do: Kernel.*(a, b)

  def map(%Product{val: val}, fun) do
    new(fun.(val))
  end

  def apply_with(%Product{val: fun}, %Product{val: val}) do
    new(fun.(val))
  end

  @doc """
  The only things that make sense to put in a %Product{} are a number,
  or a function that will eventually evaluate to a number.
  """
  def new(val) when is_number(val) or is_function(val) do
    %Product{val: val}
  end

  def chain(%Product{val: val}, function) do
    function.(val)
  end


  defp assert_value_is_number(value) do
    if is_number(value) do
      value
    else
      raise "non-numeric value passed to FunLandic.Product!"
    end
  end

end
