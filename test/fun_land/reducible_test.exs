defmodule FunLand.ReducibleTest do
  use ExUnit.Case, async: true
  use FunLand

  defmodule Score do
    defstruct [val: 0]
    use FunLand.Combinable

    def new(val), do: %Score{val: val}

    def empty() do
      new(0)
    end

    def combine(%Score{val: a}, %Score{val: b}), do: new(a + b)
  end


  doctest FunLand.Reducible
end
