defmodule FunLandic.Reader do
  @moduledoc """
  The Reader monad wraps a function that returns the contained value when asked.
  This is nice, as you can call things inside the Reader context, and only refer to the
  things inside the Reader when you require them. It thus enables lighter parameter-passing.
  """

  defstruct [:fun]
  alias __MODULE__


  use FunLand.Monad
  use Currying

  def apply_with(reader = %Reader{fun: fun}, val), do: %Reader{fun: curry(fun, val)}

  def new(x), do: %Reader{fun: curry(fn _ -> x end)}

  def chain(reader = %Reader{fun: reader_fun}, fun) do
    %Reader{fun: fn e -> fun.(run(reader, e)) end}
  end

  def run(reader = %Reader{fun: fun}, argument), do: fun.(argument)

end
