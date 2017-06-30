defmodule FunLand.Builtin.Map do
  use FunLand.Mappable

  @moduledoc """
  Maps are Mappable, because we can map over `{k, v}`-tuples to create new values.
  (
  Note that different from the `Map` implementation of `Enum.map`, the result should be a new _value_, and not a new {key, value}-tuple.
  There is no way to alter the key while mapping over a Map, as the key is part of the structure, rather than its contents!
  )

  Maps are however _not_ Appliable, (TODO: Explanation)


  Maps are _not_ Applicative, as there is no way to put 'a value' inside a map (we don't know what key to associate it with)
  so we cannot define an implementation of `new/1`.

  --------------------

  Maps _are_ SemiCombinable, as we can take two key-value groups, and combine them (with duplicates being overridden by the values in the latter).
  Maps are also Combinable, as it is also possible to create a `empty` element: an empty map.
  """

  def map(map, function) do
    :maps.map(fn k, v -> function.({k, v}) end, map)
  end

  use FunLand.Combinable

  def combine(map_a, map_b) do
    :maps.merge(map_a, map_b)
  end

  def empty do
    :maps.new
  end

  use FunLand.Reducable

  def reduce(map, initial, folding_function) do
    :maps.fold(fn k, v, acc -> folding_function.({k, v}, acc) end, initial, map)
  end
end
