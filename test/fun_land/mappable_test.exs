defmodule FunLand.MappableTest do
  use ExUnit.Case, async: true
  use FunLand

  doctest FunLand.Mappable

  test "basic mapping for lists" do
    assert [1, 2, 3] |> FunLand.Mappable.map(fn x -> x * 2 end) == [2, 4, 6]
  end

  test "basic mapping for success tuple" do
    assert {:ok, 2} |> FunLand.Mappable.map(fn x -> x * 2 end) == {:ok, 4}
    assert {:error, :bad} |> FunLand.Mappable.map(fn x -> x * 2 end) == {:error, :bad}
  end

  test "basic mapping for maps" do
    assert %{a: 1, b: 2} |> FunLand.Mappable.map(fn {_k, v} -> v * 2 end) == %{a: 2, b: 4}
  end
end
