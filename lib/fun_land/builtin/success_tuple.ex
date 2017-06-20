defmodule FunLand.Builtin.SuccessTuple do
  @moduledoc """
  Uses `{:ok, value} | :error | {:error, error}` as representation
  of the `Either` type:

  - Errors are propagated.
  """

  use FunLand
  use FunLand.Monad
  use FunLand.Reducable
  use FunLand.Traversable
  use FunLand.Combinable

  def ok?({:ok, _}), do: true
  def ok?(_), do: false

  def err?({:error, _}), do: true
  def err?(:error), do: true
  def err?(_), do: false

  defmacrop is_error(dt) do
    quote do
      unquote(dt) == :error or is_tuple(unquote(dt)) and tuple_size(unquote(dt)) == 2 and elem(unquote(dt), 0) == :error
    end
  end

  defmacrop is_ok(dt) do
    quote do
      is_tuple(unquote(dt)) and tuple_size(unquote(dt)) == 2 and elem(unquote(dt), 0) == :ok
    end
  end

  def new(val), do: {:ok, val}

  def map({:ok, val}, fun) do
      new(fun.(val))
  end
  def map(:error, _fun), do: :error
  def map({:error, reason}, _fun), do: {:error, reason}

  def apply_with(left, right) when is_error(left), do: left
  def apply_with({:ok, fun}, right), do: map(right, fun)

  def chain({:ok, val}, fun), do: fun.(val)
  def chain(error_tuple, fun), do: error_tuple

  def reduce({:ok, val}, acc, fun), do: fun.(val, acc)
  def reduce(_error_tuple, acc, _fun), do: acc
  
  # Combinable
  def neutral, do: :error

  @doc """
  Combinable only works if the type inside the success tuples
  is Combinable.
  """
  def combine(left, right) when is_error(left), do: left
  def combine(left, right) when is_error(right), do: right
  def combine({:ok, leftval}, {:ok, rightval}), do: new(FunLand.Combinable.combine(leftval, rightval))


end
