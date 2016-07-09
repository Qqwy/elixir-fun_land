defmodule Maybe do
  use FunLand.Monad

  defstruct nothing?: true, val: nil

  defimpl Inspect do
    def inspect(%Maybe{nothing?: true}, _opts), do: "#Maybe{Nothing}"
    def inspect(%Maybe{val: x}, _opts), do: "#Maybe{Just #{inspect x}}"
  end

  def nothing(), do: %Maybe{nothing?: true}
  def just(x), do: %Maybe{nothing?: false, val: x}

  def from_just(%Maybe{nothing?: false, val: x}), do: x
  def from_just(%Maybe{}), do: raise "Passed value was nothing!"


  # Monad behaviour callbacks

  def apply_with(%Maybe{nothing?: true}, _), do: nothing()
  def apply_with(_, %Maybe{nothing?: true}), do: nothing()
  def apply_with(%Maybe{val: fun}, %Maybe{val: b}) when is_function(fun, 1) do
    just(fun.(b))
  end

  def wrap(x), do: just(x)

  def chain(%Maybe{nothing?: true}, _fun), do: nothing()
  def chain(%Maybe{val: x}, fun), do: fun.(x)

end
