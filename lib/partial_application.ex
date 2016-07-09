defmodule PartialApplication do
  def partially_apply(fun, arguments = [h | t]) do
    {:arity, arity} = :erlang.fun_info(fun, :arity) 
    argument_length = length(arguments)
    cond do
      arity < argument_length ->
        raise "Too many parameters supplied to `partially_apply`!"
      arity == argument_length ->
        Kernel.apply(fun, arguments)
      arity > argument_length ->
        fn 
          later_arguments when is_list(later_arguments) -> 
            partially_apply(fun, arguments ++ later_arguments)
          later_argument ->
             partially_apply(fun, arguments ++ [later_argument])
        end
    end
  end

  def partially_apply(fun, elem), do: partially_apply(fun, [elem])

  def partially_apply(fun) do
    fn 
      later_arguments when is_list(later_arguments) -> 
        partially_apply(fun, later_arguments)
      later_argument ->
         partially_apply(fun, [later_argument])
    end
  end
end
