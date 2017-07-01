defmodule FunLand.Builtin.MapSet do
  use FunLand.Combinable
  def empty() do
    Elixir.MapSet.new()
  end

  def combine(mapset1, mapset2) do
    MapSet.union(mapset1, mapset2)
  end

  use FunLand.Reducable
  def reduce(set, acc, fun) do
    list = MapSet.to_list(set)
    :lists.foldr(fun, acc, list)
  end
end
