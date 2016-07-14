defmodule FunLand.Builtin.Map do
  use FunLand.Mappable

  @moduledoc """
  Maps are Mappable, because we can map over `{k, v}`-tuples to create new values.

  Maps are however _not_ Appliable, as there is no clearly 


  Maps are _not_ Applicative, as there is no way to put 'a value' inside a map (we don't know what key to associate it with)
  so we cannot define an implementation of `wrap/2`.
  
  --------------------

  Maps _are_ Combinable, as we can take two key-value pairs, and combine them. 
  It is also possible to create a `neutral` element: an empty map.
  """

  def map(map, function) do
    :maps.map(fn k, v -> function.({k, v}) end, map)
  end

  use FunLand.Combinable

  def combine(map_a, map_b) do
    :maps.merge(map_a, map_b)
  end

  def neural do
    :maps.new
  end

  use FunLand.Reducable

  def reduce(map, initial, folding_function) do
    :maps.fold(fn k, v, acc -> folding_function.({k, v}, acc) end, initial, map)
  end
end
