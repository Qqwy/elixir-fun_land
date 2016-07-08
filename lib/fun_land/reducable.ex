defmodule FunLand.Reducable do

  @type reducable(_) :: FunLand.adt

  @callback reduce(reducable(a), acc, (a, acc -> acc)) :: acc when a: any, acc: any

  defmacro __using__(_opts) do
    quote do
      @behaviour FunLand.Reducable
    end
  end

  def reduce(a, acc, fun) do
    do_reduce(a, acc, fun)
  end

  defp do_reduce([], acc, fun), do: acc
  defp do_reduce([h|t], acc, fun), do: do_reduce(t, fun.(h, acc), fun)


  # Using a Combinable
  def reduce(a, monoid) do
    reduce(a, monoid.neutral, &monoid.combine/2)
  end
end
