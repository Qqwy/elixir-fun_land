defmodule FunLand.Traversable do

  @type traversable(_) :: FunLand.adt

  @callback sequence(traversable(a), (a -> FunLand.Applicative.applicative(b))) :: FunLand.Applicative.applicative(traversable(b)) when a: any, b: any

  defmacro __using__(_opts) do
    quote do
      use FunLand.Mappable
      use FunLand.Reducable
    end
  end

  def sequence(seq_a, fun) do
    do_sequence(seq_a, fun)
  end

  # Problem: untyped lists. No idea what applicative to wrap with when list is empty.
  defp do_sequence(seq_a, _fun) when is_list(seq_a) do
    nil
  end
end
