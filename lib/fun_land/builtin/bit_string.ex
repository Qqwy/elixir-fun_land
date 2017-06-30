defmodule FunLand.Builtin.BitString do
  use FunLand.Combinable

  def empty, do: ""

  def combine(str_a, str_b), do: Kernel.<>(str_a, str_b)
end
