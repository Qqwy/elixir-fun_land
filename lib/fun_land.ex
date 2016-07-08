defmodule FunLand do
  # Elixir doesn't let you _really_ define abstract data types.
  @type adt :: [] | {} | %{} | struct

  defmacro __using__(_opts) do
    quote do
      alias FunLand.{
        Mappable,
        Combinable,
        Collectable,
      }
    end

  end
end
