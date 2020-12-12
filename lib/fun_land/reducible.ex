defmodule FunLand.Reducible do

  @moduledoc """
  Anything that implements the Reducible behaviour, can be reduced to a single value, when given a combinable (or combining-function + base value).

  This is enough information to convert any reducible to a List.
  It even is enough information to implement most enumerable methods.

  However, what is _not_ possible, is to stop halfway through the reduction.
  Therefore, Reducible is a lot simpler than the Enumerable protocol.

  For convenience, though, a very basic implementation of the Enumerable protocol is
  automatically added when you `use Reducible`. This implementation first converts your Reducible
  to a list, and then enumerates on that.

  This is very convenient, but it _does_ mean that your *whole* reducible is first converted to a list.
  This will therefore always be slower than a full-blown custom implementation that is specific for your structure.

  If you want to implement your own version of Enumerable, add Reducible with `use FunLand.Reducible, auto_enumerable: false`.


  """

  @type reducible(a) :: FunLand.adt(a)

  @callback reduce(reducible(a), acc, (a, acc -> acc)) :: acc when a: any, acc: any

  defmacro __using__(opts) do

    enum_protocol_implementation =
      if Keyword.get(opts, :auto_enumerable, false) do
        quote do
          defimpl Enumerable do

            def count(reducible), do: {:error, __MODULE__}
            def empty?(reducible), do: {:error, __MODULE__}
            def member?(reducible, elem), do: {:error, __MODULE__}
            def reduce(reducible, acc, fun) do
              reducible
              |> @for.to_list
              |> Enumerable.List.reduce(acc, fun)
            end
          end
        end
      else
        quote do end
      end

    unused_opts = Keyword.delete(opts, :auto_enumerable)
    if unused_opts != [] do
      IO.puts "Warning: `use FunLand.Reducible` does not understand options: #{inspect(unused_opts)}"
    end

    quote do
      @behaviour FunLand.Reducible
      unquote(enum_protocol_implementation)

      @doc """
      Converts the reducible into a list,
      by building up a list from all elements, and in the end reversing it.

      This is an automatic function implementation, made possible because #{inspect(__MODULE__)}
      implements the `FunLand.Reducible` behaviour.
      """
      def to_list(reducible) do
        reducible
        |> __MODULE__.reduce([], fn x, acc -> [x | acc] end)
        |> :lists.reverse
      end

      defoverridable to_list: 1

      @doc """
      A variant of reduce that accepts anything that is Combinable
      as second argument. This Combinable will determine what the empty value and the
      combining operation will be.

      Pass in the combinable module name to start with `empty` as accumulator,
      or the combinable as struct to use that as starting accumulator.
      """
      def reduce(a, combinable) do
        reduce(a, FunLand.Combinable.empty(combinable), &FunLand.Combinable.combine(combinable, &1))
      end
    end
  end

  def reduce(reducible, acc, fun)

  # stdlib structs
  for {stdlib_module, module} <- FunLand.Builtin.__stdlib_struct_modules__ do
    def reduce(reducible = %unquote(stdlib_module){}, acc, fun) do
      apply(unquote(module), :reduce, [reducible, acc, fun])
    end
  end

  # custom structs
  def reduce(reducible = %module{}, acc, fun) do
    module.reduce(reducible, acc, fun)
  end

  use FunLand.Helper.GuardMacros
  for {guard, module} <- FunLand.Builtin.__builtin__ do
    def reduce(reducible, acc, fun) when unquote(guard)(reducible) do
      apply(unquote(module),:reduce, [reducible, acc, fun])
    end
  end

  # Using a Combinable
  def reduce(a, combinable) do
    reduce(a, FunLand.Combinable.empty(combinable), &FunLand.Combinable.combine(combinable, &1))
  end
end
