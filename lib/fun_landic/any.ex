defmodule FunLandic.Any do
  @moduledoc """
  This Combinable can be used to combine a Reducable of boolean values, returning `true` if any of them (e.g. at least one of them) is `true`.

  Otherwise, `false` is returned.
  """

  use FunLand.Combinable

  def empty, do: false
  def combine(a, b), do: a || b
end
