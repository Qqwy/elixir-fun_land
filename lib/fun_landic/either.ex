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
  use Monad

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

  # Monad behaviour implementations

  def map(left = %Either{right?: false}, fun), do: left
  def map(%Either{right?: true, val: val}, fun), do: wrap(fun.(val))
  
  def apply_with(left = %Either{right?: false}, _), do: left
  def apply_with(%Either{right?: true, val: fun}, right = %Either{}), do: map(right, fun)

  def wrap(val), do: right(val)

  def chain(either = %Either{right?: true, val: val}, fun) do
    right(fun.(val))
  end
  def chain(either = %Either{right?: false, val: val}, _fun) do
    either
  end

end