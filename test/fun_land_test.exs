defmodule FunLandTest do
  use ExUnit.Case
  use FunLand

  doctest FunLand

  defmodule MappableStructTest do
    use FunLand.Mappable

    defstruct val: 0

    def map(mappable_struct = %MappableStructTest{val: val}, fun) do
      %MappableStructTest{mappable_struct | val: fun.(val)}
    end
  end
  alias FunLandTest.MappableStructTest

  test "mappable using a custom struct" do
    assert %MappableStructTest{ val: 3} |> FunLand.Mappable.map(fn x -> x*x end) == %MappableStructTest{val: 9}
  end
end
