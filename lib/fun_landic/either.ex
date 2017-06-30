defmodule FunLandic.Either do
  @moduledoc """
  An implementation of the "Either" monad.

  `Either` is very similar to `Maybe`, with the difference that instead of returning 'Maybe.nothing' on failure,
  you can specify what to return on failure at each step, so you know where something failed.

  TODO:

  - Verify implementation.
  - Rename to something less ambigous than 'Either'?
  """

  use FunLand
  use FunLand.Monad
  use FunLand.Reducable

  defstruct [:val, right?: true]
  alias __MODULE__

  defimpl Inspect do
    def inspect(%Either{right?: false, val: val}, _opts), do: "Either.left(#{inspect val})"
    def inspect(%Either{right?: true , val: val}, _opts), do: "Either.right(#{inspect val})"
  end

  def right(val) do
    %Either{val: val, right?: true}
  end

  def left(val) do
    %Either{val: val, right?: false}
  end

  def left?(either)
  def left?(%Either{right?: false}), do: true
  def left?(%Either{right?: true}),  do: false

  def right?(either)
  def right?(%Either{right?: false}), do: false
  def right?(%Either{right?: true}),  do: true

  @doc """
  Converts the %Either{} in the `{:ok, value} | {:error, reason}`-format.
  """
  def to_success_tuple(%Either{right?: false, val: val}) do
    {:error, val}
  end
  def to_success_tuple(%Either{right?: true, val: val}) do
    {:ok, val}
  end

  @doc """
  Turns the common `{:ok, value} | {:error, reason}`-format into an %Either{}.
  """
  def from_success_tuple({:ok, val}), do: right(val)
  def from_success_tuple(:error), do: left(nil)
  def from_success_tuple({:error, val}), do: left(val)

  def run_either(either, function_if_left, function_if_right)

  def run_either(%Either{right?: false, val: val}, function_if_left, _), do: function_if_left.(val)
  def run_either(%Either{right?: true, val: val}, _, function_if_right), do: function_if_right.(val)

  # Monad behaviour implementations

  def map(left = %Either{right?: false}, fun), do: left
  def map(%Either{right?: true, val: val}, fun), do: new(fun.(val))

  def apply_with(left = %Either{right?: false}, _), do: left
  def apply_with(%Either{right?: true, val: fun}, right = %Either{}), do: map(right, fun)

  def new(val), do: right(val)

  def chain(either = %Either{right?: true, val: val}, fun) do
    fun.(val)
  end
  def chain(either = %Either{right?: false, val: val}, _fun) do
    either
  end

  # Reducable behavior implementations

  def reduce(either, acc, fun)
  def reduce(either = %Either{right?: false}, acc, _fun), do: acc
  def reduce(either = %Either{right?: true, val: val}, acc, fun), do: fun.(val, acc)

end
