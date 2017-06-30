defmodule FunLandic.All do
  @moduledoc """
  This Combinable can be used to combine a Reducable of boolean values, returning `true` if all of them are `true`.

  Otherwise, `false` is returned.

  Note that `All` is true for an empty Reducable.
  """

  use FunLand.Combinable

  def empty, do: true
  def combine(a, b), do: a && b
end
