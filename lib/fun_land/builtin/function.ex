defmodule FunLand.Builtin.Function do
  use FunLand.Applicative
  use Currying

  @doc """
  To map for functions is the same as doing function composition.
  
  `map/2` constructs a new function that takes a single argument, which,
  when executed, feeds that argument first to the `inner_function`, and then
  feeds the result of that as argument into `outer_function`.

  TODO: Verify implementation
  """
  def map(inner_function, outer_function) do
    curry(fn x -> outer_function.(curry(inner_function.(x))) end)
  end

  @doc """

  TODO: Verify implementation
  """
  def apply_with(function_returning_a_function, inner_function) do
    fn x -> curry(function_returning_a_function.(x, inner_function.(x))) end
  end

  @doc """
  Returns a 'constant' function, which, regardless of input, returns the value
  that is passed to `pure/1`.
  """
  def pure(val), do: fn _ -> val end
end
