defmodule FunLandic.Maybe do

  defstruct nothing?: true, val: nil
  alias __MODULE__

  defimpl Inspect do
    def inspect(%Maybe{nothing?: true}, _opts), do: "FunLandic.Maybe.nothing()"
    def inspect(%Maybe{val: x}, _opts), do: "FunLandic.Maybe.just(#{inspect x})"
  end

  def nothing(), do: %Maybe{nothing?: true}
  def just(x), do: %Maybe{nothing?: false, val: x}

  @doc """
  Converts the %Maybe{} in the `{:ok, value} | :error`-format.
  """
  def to_success_tuple(%Maybe{nothing?: true}) do
    :error
  end
  def to_success_tuple(%Maybe{val: val}) do
    {:ok, val}
  end

  @doc """
  Turns the common `{:ok, value} | :error`-format into a %Maybe{}.
  """
  def from_success_tuple({:ok, val}), do: just(val)
  def from_success_tuple(:error), do: nothing()
  def from_success_tuple({:error, _}), do: nothing()

  use FunLand.CombinableMonad

  # Appliable
  def apply_with(%Maybe{nothing?: true}, _), do: nothing()
  def apply_with(_, %Maybe{nothing?: true}), do: nothing()
  def apply_with(%Maybe{val: fun}, %Maybe{val: b}) when is_function(fun, 1) do
    just(Currying.curry(fun).(b))
  end

  # Applicable
  def new(x), do: just(x)

  # Chainable
  def chain(%Maybe{nothing?: true}, _fun), do: nothing()
  def chain(%Maybe{val: x}, fun), do: fun.(x)

  # Semicombinable
  def combine(%Maybe{nothing?: true}, second = %Maybe{}), do: second
  def combine(first = %Maybe{}, _), do: first

  # Combinable
  def empty, do: nothing()

  use FunLand.Traversable

  def traverse(%Maybe{nothing?: true}, result_module, _fun) do
    result_module.new(nothing())
  end
  def traverse(%Maybe{val: val}, result_module, fun) do
    result_module.map(fun.(val), &just/1)
  end

  # Foldable
  def reduce(%Maybe{nothing?: true}, acc, _fun) do
    acc
  end

  def reduce(%Maybe{val: val}, acc, fun) do
    fun.(val, acc)
  end
end
