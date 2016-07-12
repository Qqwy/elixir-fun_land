defmodule FunLandic.Maybe do

  defstruct nothing?: true, val: nil
  alias __MODULE__

  defimpl Inspect do
    def inspect(%Maybe{nothing?: true}, _opts), do: "#Maybe{Nothing}"
    def inspect(%Maybe{val: x}, _opts), do: "#Maybe{Just #{inspect x}}"
  end

  def nothing(), do: %Maybe{nothing?: true}
  def just(x), do: %Maybe{nothing?: false, val: x}

  def from_just(%Maybe{nothing?: false, val: x}), do: x
  def from_just(%Maybe{}), do: raise "Passed value was nothing!"


  # Monad behaviour callbacks

  use FunLand.CombinableMonad

  # Appliable
  def apply_with(%Maybe{nothing?: true}, _), do: nothing()
  def apply_with(_, %Maybe{nothing?: true}), do: nothing()
  def apply_with(%Maybe{val: fun}, %Maybe{val: b}) when is_function(fun, 1) do
    just(Currying.curry(fun).(b))
  end

  # Applicable
  def wrap(x), do: just(x)

  # Chainable
  def chain(%Maybe{nothing?: true}, _fun), do: nothing()
  def chain(%Maybe{val: x}, fun), do: fun.(x)

  # Semicombinable
  def combine(%Maybe{nothing?: true}, second = %Maybe{}), do: second
  def combine(first = %Maybe{}, _), do: first

  # Combinable
  def neutral, do: nothing()



  use FunLand.Traversable

  def traverse(%Maybe{nothing?: true}) do 

  end

  def reduce(%Maybe{nothing?: true}, acc, _fun) do 
    #IO.inspect(__ENV__) 
    acc
  end

  def reduce(%Maybe{val: x}, acc, fun) do 
    #IO.inspect(__ENV__) 
    fun.(x, acc) 
  end

  # Combinable


end
