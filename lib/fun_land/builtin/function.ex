defmodule FunLand.Builtin.Function do
  use FunLand.Mappable
  use Currying

  def map(inner_function, outer_function) do
    curry(outer_function, inner_function.())
  end
end
