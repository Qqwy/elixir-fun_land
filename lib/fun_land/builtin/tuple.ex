defmodule FunLand.Builtin.Tuple do

  use FunLand
  use FunLand.Mappable

  def map(tuple, function) do
    tuple
    |> Tuple.to_list
    |> fn list -> :lists.map(function, list) end.()
    |> List.to_tuple
  end
end
