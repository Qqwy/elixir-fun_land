defmodule FunLand.Mappable do
  @moduledoc """
  Something is Mappable if you can map a function over it, which will transform its contents
  without changing its structure.

  So if you map a peel-my-fruit function over a box with bananas, you end up with a box of peeled bananas.

  If you map &(+2) over a list of numbers, you end up with a list of numbers that are two higher than before.

  etc.

  In Category Theory, something that is Mappable is called a *Functor*.
  """
  @type mappable(_) :: FunLand.adt
  @callback map(mappable(a), (a -> b)) :: mappable(b) when a: any, b: any

  def __using__(_opts) do
    quote do
      @behaviour FunLand.Mappable
    end
  end

  def map(mappable, function) when is_function(function, 1) do
    do_map(mappable, function)
  end

  # Lists
  defp do_map(list, function) when is_list(list) do
    :lists.map(function, list)
  end

  # Tuples; Not fast, but possible
  defp do_map(tuple, function) when is_tuple(tuple) do
    tuple 
    |> Tuple.to_list 
    |> fn list -> :lists.map(function, list) end.() 
    |> List.to_tuple
  end

  # Structs with user-defined specification.
  defp do_map(mappable = %mappable_module{}, function) do
    mappable_module.map(mappable, function)
  end

  # Maps.
  defp do_map(map = %{}, function) do
    # The passed function ought to have arity 1. For maps, this therefore means converting 
    # the two arguments from :maps.map to a {k, v} tuple.
    :maps.map(fn k, v -> function.({k, v}) end, map)
  end
end