defmodule Sum do
  use FunLand.Combinable

  def neutral, do: 0
  def combine(a, b), do: Kernel.+(a, b)
end