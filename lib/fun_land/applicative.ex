defmodule FunLand.Applicative do
  @doc """
  A structure is Applicative if it is Appliable, as well as having the ability to create a new structure from any value, by `new`ping it.

  Being able to create `new`, `apply` and `map` means that we can create new structures with some values, transform them and (partially or fully) apply them to each other.

  Therefore, we're able to re-use all new our old operations in a new, more complex context.



  ## Fruit Salad Example

  We've already seen that a fruit-salad bowl is `Mappable` and `Appliable`.

  However, we'd like to know how we start out: When we have an apple, how do we end up with a bowl filled with an apple?

  `Bowl.new(my_apple)` is the implementation that answers this question.

  Together with `apply` and `map`, we can now take arbitrary ingredients, put them in bowls and mix and mash them together to our liking, *without soiling the kitchen's countertop*:

  - `new`: We can take an apple, and put it in a bowl: we put the apple in a `new` bowl to return a `bowl with an apple`.
  - `apply`: If we have a bowl with a partially-made fruit-salad, and we have a bowl with an apple, we can take the apple and the partially-made fruit salad to create a bowl with a fruit-with-apples-salad.
  - `map`: We can take a bowl with any fruit or salad, and do some arbitrary operation with it, such as 'blending'. In this example, we end up with the same bowl, but now filled with blended fruit-salad.

  ## In Other Environments

  - In Haskell, `Applicative.new` is known by `pure` as well as `return`.
  - In Category Theory, something that is Applicative is know as its more official name *Applicative Functor*.


  """
  @type applicative(a) :: FunLand.adt(a)

  @callback new(a) :: applicative(a) when a: any

  defmacro __using__(_opts) do
    quote do
      use FunLand.Appliable
      @behaviour FunLand.Applicative

      @doc "Free implementation new Mappable.map as #{inspect(__MODULE__)} is Applicative"
      def map(a, function) do
        apply_with(new(function), a)
      end
      defoverridable [map: 2]

      defdelegate apply_discard_left(a, b), to: FunLand.Applicative
      defdelegate apply_discard_right(a, b), to: FunLand.Applicative

    end
  end

  defdelegate map(a, fun), to: FunLand.Mappable
  defdelegate apply_with(a, b), to: FunLand.Appliable

  # Note difference new callback and implementation; we need two parameters here.

  @doc """
  Creates a new Algebraic Data Type that contains `value`.
  The first parameter can either be the module name of the Algebraic Data Type that you want to create,
  or it can be an instance of the same data type, such as `[]` for `List`, `{}` for Tuple, `%YourModule{}` for `YourModule`.
  """
  def new(module_or_data_type, value)

  # For standard-library modules like `List`, delegate to e.g. `FunLand.Builtin.List`
  for {stdlib_module, module} <- FunLand.Builtin.__stdlib__ do
    def new(unquote(stdlib_module), a) do
      apply(unquote(module), :new, [a])
    end
  end

  # When called with custom modulename
  def new(module, a) when is_atom(module), do: module.new(a)

  # When called with stdlib struct
  for {stdlib_module, module} <- FunLand.Builtin.__stdlib_struct_modules__ do
    def new(%unquote(stdlib_module){}, a) do
      apply(unquote(module), :new, [a])
    end
  end

  # When called with Struct
  def new(%module{}, a), do: module.new(a)

  use FunLand.Helper.GuardMacros
  for {guard, module} <- FunLand.Builtin.__builtin__ do
    # When called with direct types like `{}` or `[]` or `"foo"`
    def new(applicative, a) when unquote(guard)(applicative) do
      apply(unquote(module), :new, [a])
    end
  end


  # Free function implementations:

  @doc """
  Calls `Applicative.apply/2`, but afterwards discards the value that was the result of the rightmost argument.
  (the one evaluated the last).

  So in the end, the value that went in as left argument
  (The Algorithmic Data Type containing partially-applied functions) is returned.

  In Haskell, this is known as `<*`
  """
  # TODO: Verify implementation.
  def apply_discard_right(a, b) do
    apply_with(map(a, Currying.curry(&FunLand.Helper.const/2)), b)
  end

  @doc """
  Calls `Applicative.apply/2`, but afterwards discards the value that was the result of the leftmost argument.
  (the one evaluated the first).

  So in the end, the value that went in as right argument
  (The Algorithmic Data Type containing values) is returned.

  In Haskell, this is known as `*>`
  """
  # TODO: Verify implementation.
  def apply_discard_left(a, b) do
    apply_with(map(a, Currying.curry(&FunLand.Helper.const_reverse/2)), b)
  end

end
