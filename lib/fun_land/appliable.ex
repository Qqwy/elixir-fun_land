defmodule FunLand.Appliable do
  @doc """
  Something is Appliable if you can _apply_ one of it (containing one or multiple functions) _with_ another. 
  
  Appliable is mostly born out of the needs to apply a function that is already wrapped in a Mappable: 
  
  - If you had a bare function, you could use `Mappable.map/2` to apply it over a Mappable.
  - If however, you have a function already inside a Mappable, a new operation has to be defined to apply it over a Mappable (of the same kind).

  This operation is called `apply_with/2`.

  _________

  To be Appliable something also has to be Mappable.
  To make your data structure Appliable, use `use Appliable` in its module, and implement both Appliable's `apply_with/2` and Mappable's `map/2`.

  ## Fruit Salad Example

  Say we have a bowl with a partiall-made fruit-salad.
  We have a second bowl, which contains some (peeled) bananas.

  We would like to add these bananas to the fruit salad.

  This would be easy if we had our partially-made fruit-salad, as we could just _map_ the 'combine a banana with some fruit salad' operation over the bowl of bananas.

  However, we don't 'just' have the partially-made fruit-salad, as this would make a big mess of our kitchen countertop.
  In fact, it is very likely that this bowl-with partially-made fruit salad was the result of combining (`mapping`) earlier ingredients in bowls.

  So, we need something similar to `map`, but instead of taking 'just' an operation, we use a bowl with that operation.

  For the fruit salad bowl, we could define it as 'take some fruit-salad from Bowl A, combine it with a banana in Bowl B. -> repeat until bananas and fruit-salad are fully combined'.


  This is called `apply_with`. 
  Note that, because the part that changes more often is the Appliable with the (partially-applied) function (in other words: The bowl with the partially-made fruit salad),
  the parameters of this functions are the reverse of `Mappable.map`.



  ## In Other Environments

  - In Haskell, `Appliable.apply_with` is known by the uninformative name `ap`, often written as `<$>`. 
  - In Category Theory, something that is Appliable is called an *Apply*.


  """
  @type appliable(_) :: FunLand.adt

  @callback apply_with(appliable((b -> c)), appliable(b)) :: appliable(c) when b: any, c: any

  defmacro __using__(_opts) do
    quote do
      use FunLand.Mappable
      @behaviour FunLand.Appliable
    end
  end

  
  defdelegate map(mappable, fun), to: FunLand.Mappable

  def apply_with(a, b) do
    do_apply_with(a, b)
  end

  defp do_apply_with(a = %appliable_module{}, b = %appliable_module{}) do
    appliable_module.apply_with(a, b)
  end

  # This implementation of `ap` is returning all possible solutions of combining the function(s) in `a` with the elements of `b`, AKA the cartesion product.
  defp do_apply_with(_fun_a=[], _b = [_|_]), do: []
  defp do_apply_with(_fun_a=[h|t], b = [_|_]) do
    partial_results = for elem <- b, do: h.(elem)
    partial_results ++ do_apply_with(t, b)
  end



end
