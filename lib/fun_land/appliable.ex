defmodule FunLand.Appliable do
  @doc """
  Something is Appliable if you can ap one of it (containing a function) to another. 
  
  In Category Theory, something that is Appliable is called an *ap*. ??
  """
  @type appliable(_) :: FunLand.adt

  @callback ap(appliable((b -> c)), appliable(b)) :: appliable(c) when b: any, c: any

  defmacro __using__(_opts) do
    quote do
      use FunLand.Mappable
      @behaviour FunLand.Appliable
    end
  end

  def ap(a, b) do
    do_ap(a, b)
  end

  defp do_ap(a = %appliable_module{}, b = %appliable_module{}) do
    appliable_module.ap(a, b)
  end

  # This implementation of `ap` is returning all possible solutions of combining the function(s) in `a` with the elements of `b`, AKA the cartesion product.
  defp do_ap(fun_a=[], b = [_|_]), do: []
  defp do_ap(fun_a=[h|t], b = [_|_]) do
    partial_results = for elem <- b, do: h.(elem)
    partial_results ++ do_ap(t, b)
  end

end