defmodule FunLand.Reducable do

  @moduledoc """
  Anything that implements the Reducable behaviour, can be reduced to a single value, when given a combinable (or combining-function + base value).

  This is enough information to convert any reducable to a List.
  It even is enough information to implement most enumerable methods.

  However, what is _not_ possible, is to stop halfway through the reduction.
  Therefore, Reducable is a lot simpler than the Enumerable protocol.

  For convenience, though, a very basic implementation of the Enumerable protocol is
  automatically added when you `use Reducable`. This implementation first converts your Reducable
  to a list, and then enumerates on that.

  This is very convenient, but it _does_ mean that your *whole* reducable is first converted to a list.
  This will therefore always be slower than a full-blown custom implementation that is specific for your structure.

  If you want to implement your own version of Enumerable, add Reducable with `use FunLand.Reducable, auto_enumerable: false`.


  """

  @type reducable(_) :: FunLand.adt

  @callback reduce(reducable(a), acc, (a, acc -> acc)) :: acc when a: any, acc: any

  defmacro __using__(opts) do

    enum_protocol_implementation =
      if Keyword.get(:auto_enumerable, false) do
        quote do
          defimpl Enumerable do

            def count(reducable), do: {:error, __MODULE__}
            def empty?(reducable), do: {:error, __MODULE__}
            def member?(reducable, elem), do: {:error, __MODULE__}
            def reduce(reducable, acc, fun) do
              reducable
              |> @for.to_list
              |> Enumerable.List.reduce(acc, fun)
            end
          end
        end
      else
        quote do end
      end

    quote do
      @behaviour FunLand.Reducable

      @doc """
      Converts the reducable into a list,
      by building up a list from all elements, and in the end reversing it.


      This is an automatic function implementation, made possible because #{__MODULE__} 
      implements the `FunLand.Reducable` behaviour.
      """
      def to_list(reducable) do
        reducable
        |> __MODULE__.reduce([], fn x, acc -> [x | acc] end)
        |> :lists.reverse
      end

      @doc """
      A variant of reduce/3 that accepts anything that is Combinable
      as second argument. This Combinable will determine what the neutral value and the
      combining operation will be.
      """
      def reduce(a, combinable) do
        reduce(a, combinable.neutral, &combinable.combine/2)
      end


      unquote(enum_protocol_implementation)
    end
  end

  def reduce(reducable, acc, fun)

  # custom behaviour
  def reduce(reducable = %module{}, acc, fun) do
    module.reduce(reducable, acc, fun)
  end

  for {guard, module} <- FunLand.Builtin.__builtin__ do
    def reduce(reducable, acc, fun) when unquote(guard)(reducable) do
      apply(unquote(module),:reduce, [reducable, acc, fun])
    end
  end

  # lists
  # defp do_reduce([], acc, _fun), do: acc
  # defp do_reduce([h|t], acc, fun), do: do_reduce(t, fun.(h, acc), fun)



  # Using a Combinable
  def reduce(a, combinable) do
    reduce(a, combinable.neutral, &combinable.combine/2)
  end
end
