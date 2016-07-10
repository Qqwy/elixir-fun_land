defmodule DoNotation do
  defmacro monadic(monad, do: block) do
      IO.puts(Macro.to_string(block))
      res = 
        case block do
          {:__block__, meta, lines} -> desugar_monadic_lines(monad, lines)
          line -> desugar_monadic_lines(monad, [line]) 
        end
      IO.puts(Macro.to_string(res))
      transformed_wrap_res = transform_wrap(monad, res)
      IO.puts(Macro.to_string(transformed_wrap_res))
      transformed_wrap_res
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
            unquote(monad).fail(failed_result)
        end)
    end]
  end


  defp transform_wrap(monad, {:wrap, _, [arg]} ) do
    quote do unquote(monad).wrap(unquote(arg)) end
  end
  defp transform_wrap(monad, {call, meta, args}) do
    {call, meta, transform_wrap(monad, args)}
  end
  defp transform_wrap(monad, list) when is_list(list) do
    Enum.map(list, &transform_wrap(monad, &1))
  end
  defp transform_wrap(monad, {lhs, rhs}) do
    { transform_wrap(monad, lhs), transform_wrap(monad, rhs) }
  end
  defp transform_wrap(_monad, x) do
    x
  end

end
