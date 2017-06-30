defmodule FunLand do
  @moduledoc """
  FunLand defines many different Algebraic Data Types.

  An Algebraic Data Type is nothing more, than a 'container' for some other data type.
  Exactly how that 'container' behaves is what makes one ADT different from another.

  Lists are ADTs. And so are Maps. And Sets. And Tuples. And many other things.

  Algebraic Data Types contain no value of their own. They get a value, once you fill them with something,
  and then have useful operations you can perform on their contents.

  There are many similarities in the way the different ADTs work. This allows us to define behaviours which
  generalize to all ADTs. Any of your custom data types that you can implement one or multiple of these behaviours for,
  is an ADT, and will receive the benefits that the implemented ADTs give.

  Another nice thing about this generalization, is that there is no 'learning a new API' necessary when
  switching to one thing-that-is-an-ADT to the next.

  To easily use FunLand in your code, call `use FunLand`, which will alias for you:

  - `Mappable` -> A structure is Mappable if there is a way to map a function over it: transforming the contents but keeping the structure.
  - `Appliable` -> A structure is Applibable if it is Mappable and, given two of them where the first contains a partially-applied function, you can apply them together.
  - `Applicative` -> A structure is Applicative if it is Appliable and you can create a new one by wrapping any value.
  - `Chainable` -> A structure is Chainable if it is Appliable and you can chain multiple operations after each other, resulting in just a single structure.
  - `Monad` -> A structure is a Monad if it is both Applicative and Chainable.
  - `Semicombinable` -> A structure is Semicombinable if there is a way to combine two structures into one.
  - `Combinable` -> A structure is Combinable if it is Semicombinable and there is a clearly defined 'empty' element.
  - `CombinableMonad` -> A structure is a CombinableMonad if it is both Combinable and a Monad.
  - `Reducable` -> A structure is reducable if you can fold/reduce it to a single value, when giving a Combinable or function+default.
  - `Traversable` -> A structure is Traversable if it is Reducable and there is a way to flip the ???

  When given the option `operators: true`, it will also import the following operators:

  - `~>` Shorthand for `Mappable.map/2`
  - `<~>` Shorthand for `Appliable.apply_with/2`
  - `~>>` Shorthand for `Chainable.chain/2`
  - `<>` Shorthand for `Combinable.combine/2`. This operator still works the same for binaries, but will now also work for any other Chainable.

  """

  # Elixir doesn't let you _really_ define algebraic data types, so we're creating a 'one type fits all' type.
  @type adt :: [any] | {} | map | struct

  defmacro __using__(opts) do

    # Only import operators if wanted.
    import_code =
      if Keyword.get(opts, :operators, false) do
        quote do
          import Kernel, except: [<>: 2]
          import FunLand, only: [<>: 2, ~>: 2, <~>: 2, ~>>: 2]
        end
      else
        quote do
          import Kernel
        end
      end

    quote do
      unquote(import_code)

      alias FunLand.{
        Mappable,
        Appliable,
        Applicative,
        Chainable,
        Monad,

        Semicombinable,
        Combinable,

        Reducable,
        Traversable,

        CombinableMonad,
      }
    end
  end

  defdelegate map(mappable, fun), to: FunLand.Mappable
  defdelegate apply_with(appliable_with_fun, appliable), to: FunLand.Appliable
  defdelegate new(module, value), to: FunLand.Applicative
  defdelegate chain(chainable, fun_returning_chainable), to: FunLand.Chainable
  defdelegate empty(module), to: FunLand.Combinable
  defdelegate combine(semicombinable, semicombinable), to: FunLand.Semicombinable
  defdelegate reduce(reducable, accumulator, fun), to: FunLand.Reducable
  defdelegate reduce(reducable, combinable), to: FunLand.Reducable

  def any?(reducable, property_fun) do
    FunLand.Reducable.reduce(reducable, false, fn elem, acc -> acc || property_fun.(elem) end)
  end

  def all?(reducable, property_fun) do
    FunLand.Reducable.reduce(reducable, true, fn elem, acc -> acc && property_fun.(elem) end)
  end

  @doc """
  Infix version of `FunLand.Mappable.map/2`
  """
  def a ~> b do
    FunLand.Mappable.map(a, b)
  end

  @doc """
  Infix version of `FunLand.Appliable.apply_with/2`
  """
  def a <~> b do
    FunLand.Appliable.apply_with(a, b)
  end

  @doc """
  Infix version of `FunLand.Chainable.chain/2`
  """
  def a ~>> b do
    FunLand.Chainable.chain(a, b)
  end

  # This operator is made more general. It still works for binary combining, as binaries are indeed Combinable.
  @doc """
  Infix version of `FunLand.Combinable.combine/2`.

  Note that binary strings are Combinable, so "foo" <> "bar" still works.

  `<>/2` can still be used in pattern-matches and guard clauses, but it will fall back to the
  behavior of `Kernel.<>/2`, which means that it will only work with binary strings.
  """
  defmacro left <> right do
    in_module? = (__CALLER__.context == nil)
    if in_module? do
      quote do
        FunLand.Combinable.combine(unquote(left), unquote(right))
      end
    else
      quote do
        Kernel.<>(unquote(left), unquote(right))
      end
    end
  end
end
