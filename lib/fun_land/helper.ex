defmodule FunLand.Helper do
  @moduledoc """
  FunLand Helper functions for some common Algorithmic Data Type implementations.
  """

  @doc """
  The identity function: Returns what was passed in, unchanged.
  """
  def id(x), do: x

  @doc """
  The constant function: Returns the first argument, regardless of the second argument.
  """
  def const(x, _y), do: x

  @doc """
  The constant function, reversed: Returns the second argument, regardless of the first argument.
  """
  def const_reverse(_x, y), do: y
end
