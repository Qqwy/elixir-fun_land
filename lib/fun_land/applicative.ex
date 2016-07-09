defmodule FunLand.Applicative do
  @doc """
  A structure is Applicative if it is Appliable, as well as having the ability to create a new structure from any value, by `wrap`ping it.

  Being able to `wrap`, `apply` and `map` means that we can create new structures with some values, transform them and (partially or fully) apply them to each other.

  Therefore, we're able to re-use all wrap our old operations in a new, more complex context.


  

  ## Fruit Salad Example

  We've already seen that a fruit-salad bowl is `Mappable` and `Appliable`.

  However, we'd like to know how we start out: When we have an apple, how do we end up with a bowl filled with an apple?

  `wrap` is the implementation that answers this question.

  Together with `apply` and `map`, we can now take arbitrary ingredients, put them in bowls and mix and mash them together to our liking, *without soiling the kitchen's countertop*:
  
  - `wrap`: We can take an apple, and put it in a bowl: we `wrap` the apple to return a `bowl with an apple`.
  - `apply`: If we have a bowl with a partially-made fruit-salad, and we have a bowl with an apple, we can take the apple and the partially-made fruit salad to create a bowl with a fruit-with-apples-salad.
  - `map`: We can take a bowl with any fruit or salad, and do some arbitrary operation with it, such as 'blending'. In this example, we end up with the same bowl, but now filled with blended fruit-salad. 

  ## In Other Environments

  - In Haskell, `Applicative.wrap` is known by `pure` as well as `return`.
  - In Category Theory, something that is Applicative is know as its more official name *Applicative Functor*.


  """
  @type applicative(_) :: FunLand.adt

  # TODO: Best name? `wrap`, `wrap`?
  @callback wrap(a) :: applicative(a) when a: any

  defmacro __using__(_opts) do
    quote do
      use FunLand.Appliable
      @behaviour FunLand.Applicative

      @doc "Free implementation wrap Mappable.map for Applicative"
      def map(a, function) do
        a
        |> wrap
        |> apply_with(function)
      end

      defoverridable [map: 2]
    end
  end

  
  defdelegate apply_with(a, b), to: FunLand.Appliable

  # Note difference wrap callback and implementation; we need two parameters here.
  def wrap([], a), do: [a]
  def wrap(List, a), do: [a]
  def wrap(module, a) when is_atom(module), do: module.wrap(a)


  def apply_discard_right(a = %module{}, b = %module{}) do
    apply_with(wrap(module, fn _ -> a end), b)
  end

  def apply_discard_right(a, b) when is_list(a) and is_list(b) do
    apply_with(wrap([], fn _ -> a end), b)
  end



  def apply_discard_left(a = %module{}, b = %module{}) do
    apply_with(wrap(module, fn _ -> b end), b)
  end

  def apply_discard_left(a, b) when is_list(a) and is_list(b) do
    apply_with(wrap([], fn _ -> b end), b)
  end


end