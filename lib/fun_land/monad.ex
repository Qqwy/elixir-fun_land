defmodule FunLand.Monad do
  @moduledoc """
  A Monad is something that is a Monad.
  
  To be a Monad, something has to be Applicative, as well as Chainable.

  Something that is a Monad has four operations:

  - `wrap`, which allows us to put anything inside a new structure of this kind.
  - `map`, which allows us to take a normal function transforming one element, and change it into a function that transforms all of the contents of the structure.
  - `chain`, which allows us to take a function that usually returns a new structure of this kind, and instead apply it on an already-existing structure, the result being a single new structure instead of multiple layers of it.
  - `apply_with`, which allows us to take a partially-applied function _inside_ a structure of this kind to be applied with another structure of this kind.

  This allows us to:

  - Take any normal value and put it into our new structure.
  - Use any normal functions as well as any functions returning a structure of this kind to be used in a sequence of operations.
  - determine what should happen between subsequent operations. (when/how/if the next step should be executed)


  """

  defmacro __using__(_opts) do
    quote do
      use FunLand.Applicative
      use FunLand.Chainable

      defmacro monadic(do: block) do
        quote do
          require FunLand.Monad
          FunLand.Monad.monadic(unquote(__MODULE__), do: unquote(block))
        end
      end

      @doc """
      This is called internally whenever a `YourMonad.chain()` operation fails.

      For most monads, the default behaviour of crashing is great.
      For some, you might want to override it.
      """
      def fail(var, expr) do
        raise "The monadic pattern match #{Macro.to_string(var)} failed in #{Macro.to_string(expr)}"
      end
      defoverridable [fail: 2]

    end
  end


  defdelegate apply_with(a, b), to: FunLand.Appliable
  defdelegate wrap(module, a), to: FunLand.Applicative
  defdelegate chain(a, b), to: FunLand.Chainable


  # TODO: Implement `fail`. Or separate this into another behaviour?

  defmacro monadic(monad, do: block) do
      IO.puts(Macro.to_string(block))
      res = 
        case block do
          nil ->
            raise ArgumentError, message: "missing or empty do block"
          {:__block__, meta, lines} -> 
            {:__block__, meta, [quote do import unquote(monad) end | desugar_monadic_lines(monad, lines)]}
          line -> 
            {:__block__, [], [quote do import unquote(monad) end | desugar_monadic_lines(monad, [line])]}
        end
      IO.puts(Macro.to_string(res))
      res
      # transformed_wrap_res = transform_wrap(monad, res)
      # IO.puts(Macro.to_string(transformed_wrap_res))
      # transformed_wrap_res
  end

  defp desugar_monadic_lines(_, [line = {:<-, _, [var, expr]}]) do
    raise "\"#{Macro.to_string(line)}\"  `<-` cannot appear on the last line of a monadic do block"
  end

  defp desugar_monadic_lines(_, [single_line]) do
    [single_line]
  end

  # x <- foo ==> chain(foo, fn x -> ... end)
  defp desugar_monadic_lines(monad, [{:<-, _, [var, expr]} | lines]) do
    desugar_monadic_chain(monad, var, expr, lines)
  end
  
  # foo ==> chain(foo, fn _ -> ... end)
  defp desugar_monadic_lines(monad, [expr | lines]) do
    desugar_monadic_chain(monad, quote(do: _), expr, lines)
  end
  
  # TODO: >> == *> == apply_discard_left?

  # foo ==> apply_discard_left(foo, ...)
  # def desugar_monadic_lines(monad, [expr | lines]) do
  #   [quote do
  #     unquote(monad).apply_discard_left(
  #       unquote(expr), 
  #       unquote_splicing(desugar_monadic_lines(monad, lines))
  #     )
  #   end]
  # end

  defp desugar_monadic_chain(monad, var, expr, lines) do
    [quote do
      unquote(monad).chain(unquote(expr), 
        fn 
          unquote(var) ->
            unquote_splicing(desugar_monadic_lines(monad, lines))
          failed_result ->
            unquote(monad).fail(unquote(Macro.escape(var)), failed_result)
        end)
    end]
  end


  # defp transform_wrap(monad, {:wrap, _, [arg]} ) do
  #   quote do unquote(monad).wrap(unquote(arg)) end
  # end
  # defp transform_wrap(monad, {call, meta, args}) do
  #   {call, meta, transform_wrap(monad, args)}
  # end
  # defp transform_wrap(monad, list) when is_list(list) do
  #   Enum.map(list, &transform_wrap(monad, &1))
  # end
  # defp transform_wrap(monad, {lhs, rhs}) do
  #   { transform_wrap(monad, lhs), transform_wrap(monad, rhs) }
  # end
  # defp transform_wrap(_monad, x) do
  #   x
  # end


end
