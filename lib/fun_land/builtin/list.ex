defmodule FunLand.Builtin.List do
  use FunLand

  use FunLand.CombinableMonad

  def map(list, function) do
    :lists.map(function, list)
  end

  # This implementation of `ap` is returning all possible solutions of combining the function(s) in `a` with the elements of `b`, AKA the cartesion product.
  def apply_with([], b) when is_list(b), do: []
  def apply_with([h | t], b) when is_list(b) and is_function(h) do
    partial_results = for elem <- b do
      h.(elem)
    end
    partial_results ++ apply_with(t, b)
  end

  def new(elem), do: [elem]
  def empty, do: []

  def chain(list, fun) do
    for elem <- list, result <- fun.(elem) do
      result
    end
  end

  def combine(list_a, list_b) do
    list_a ++ list_b
  end

  use FunLand.Reducable

  def reduce(list, acc, fun) do
    :lists.foldr(fun, acc, list)
  end

  use FunLand.Traversable

  @doc """

  An Example of using traverse:

      iex> FunLand.Traversable.traverse([1, 2, 3], FunLandic.Maybe, fn x -> FunLandic.Maybe.just(x) end)
      FunLandic.Maybe.just([1, 2, 3])
      iex> FunLand.Traversable.traverse([1, 2, 3], [], fn x -> [x,x] end)
      [[1, 2, 3], [1, 2, 3], [1, 2, 3], [1, 2, 3], [1, 2, 3], [1, 2, 3], [1, 2, 3],
      [1, 2, 3]]

  """
  def traverse(list, result_module, fun) do
    cons_fun = fn elem, acc ->
      result_module.map(fun.(elem), Currying.curry(&cons/2))
      |> result_module.apply_with(acc)
    end
    reduce(list, result_module.new([]), cons_fun)
  end

  defp cons(head, tail), do: [head | tail]
end
