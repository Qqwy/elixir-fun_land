defmodule FunLand.Helper.GuardMacros do
  defmacro __using__(_opts) do
    quote do

      # Returns `true` if `datatype` is one of:
      # `{:ok, value}`
      # `{:error, value}`
      # `:error`
      defmacro is_success_tuple(datatype) do
        res = quote do
          unquote(datatype) == :error or is_tuple(unquote(datatype)) and tuple_size(unquote(datatype)) == 2 and elem(unquote(datatype), 0) in [:ok, :error]
        end
        IO.puts(Macro.to_string(res))
        res
      end
    end
  end
end
