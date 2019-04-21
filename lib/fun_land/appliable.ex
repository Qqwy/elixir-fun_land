defmodule FunLand.Appliable do
  @moduledoc """
  Something is Appliable if you can _apply_ one of it (containing one or multiple functions) _with_ another.

  Appliable is mostly born out of the needs to apply a function that is already wrapped in a Mappable:

  - If you had a bare function, you could use `Mappable.map/2` to apply it over a Mappable.
  - If however, you have a function already inside a Mappable, a new operation has to be defined to apply it over a Mappable (of the same kind).

  This operation is called `apply_with/2`.

  'a function inside a Mappable' is something that happens when you partially apply functions, which isn't that common in Elixir because functions are not automatically curried.

  ### Currying and Partial Application

  As `apply_with` works only applies a single argument per function at a time, it works the best when used with curried functions.
  In Elixir, functions are no curried by default.
  Fortunately, there exists the [Currying](https://hex.pm/packages/currying) library, which transforms your normal functions into curried functions.

  If you want to be able to use Applicative to its fullest potential, instead of calling `fun.(b)` in your implementation, use `Currying.curry(fun).(b)`

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
  @type appliable(a) :: FunLand.adt(a)

  @callback apply_with(appliable((b -> c)), appliable(b)) :: appliable(c) when b: any, c: any

  defmacro __using__(_opts) do
    quote do
      use FunLand.Mappable
      @behaviour FunLand.Appliable
    end
  end

  defdelegate map(a, fun), to: FunLand.Mappable

  @doc """
  Applies `appliable_with_function_inside`, which should only contain functions, with as arguments
  the elements inside `appliable_b`.

  For a List, this means that the list(s) that are made by mapping each of the functions inside
  `appliable_with_function_inside` over the elements of `appliable_b` are concatenated, so a single list of all
  results is returned.

      iex> [&(&1 + 1), &(&1 - 1)] |> FunLand.Appliable.apply_with([1, 2])
      [2, 3, 0, 1]
      iex> [Currying.curry(&+/2), Currying.curry(&-/2)] |> FunLand.Appliable.apply_with([10, 20]) |> FunLand.Appliable.apply_with([3,4])
      [13, 14, 23, 24, 7, 6, 17, 16]

  For `Maybe`, whenever one of the two arguments is `Nothing`, `Nothing` will be returned. If both are filled, then a result will be computed,
  and this result will be returned, wrapped in a new Maybe.

  """
  def apply_with(appliable_with_function_inside, appliable_b)

  # stdlib structs
  for {stdlib_module, module} <- FunLand.Builtin.__stdlib_struct_modules__ do
    def apply_with(a = %unquote(stdlib_module){}, b = %unquote(stdlib_module){}) do
      apply(unquote(module), :apply_with, [a, b])
    end
  end

  def apply_with(a = %appliable_module{}, b = %appliable_module{}) do
    appliable_module.apply_with(a, b)
  end

  use FunLand.Helper.GuardMacros
  for {guard, module} <- FunLand.Builtin.__builtin__ do
    def apply_with(a, b) when unquote(guard)(a) and unquote(guard)(b) do
      apply(unquote(module), :apply_with, [a, b])
    end
  end
end
