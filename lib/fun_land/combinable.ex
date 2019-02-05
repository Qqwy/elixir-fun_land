defmodule FunLand.Combinable do
  @moduledoc """
  If an operation is can combine two elements, and there is a clearly defined `empty` empty version
  that can be used to keep the same element when used on an element.

  In Category Theory, something that is Combinable is called a *Monoid*.

  By doing `use FunLand.Combinable` you get an implementation of the `Collectable` protocol for free.
  If you want to implement your own version of Collectable, add Combinable with `use FunLand.Combinable, auto_collectable: false`.

  ## Examples

  - Integer-addition with 0 as empty element forms a Monoid, also known as the Sum.
  - Integer-multiplication with 1 as empty element forms a Monoid, also known as the Product.
  - List concatenation with `[]` as empty element.
  - String concatenation with the empty string `""` as empty element.
  - Set union with the empty set as empty element.

  ## Fruit Salad Example

  Bowls that you can use to mix fruits in, are a monoid:

  The `combine` operation would be to put the fruits from Bowl A into Bowl B, keeping that one.
  The `empty` operation would be to take an emtpy bowl.

  As can be seen, this follows the Combinable laws:

  - left-identity: putting the contents of an empty bowl into a bowl with apples, would be the same as doing nothing (you still have 'a bowl with apples')
  - right-identity: putting the contents a bowl filled with apples into an empty bowl, would be the same as doing nothing (you still have 'a bowl with apples')

  """

  @type combinable(a) :: FunLand.adt(a)

  @callback empty() :: combinable(a) when a: any

  defmacro __using__(opts) do

    collectable_implementation =
      if Keyword.get(opts, :auto_collectable, false) do
        quote do
          defimpl Collectable do
            # def into(coll_a, {:cont, coll_b}) do
            #   FunLand.Combinable.combine(coll_a, coll_b)
            # end
            def into(original) do
              result = fn
                coll_a, {:cont, coll_b} -> FunLand.Combinable.combine(coll_a, coll_b)
                coll_a, :done -> coll_a
                coll_a, :halt -> :ok
              end
              {original, result}
            end
          end
        end
      else
        quote do end
      end

    unused_opts = Keyword.delete(opts, :auto_collectable)
    if unused_opts != [] do
      IO.puts "Warning: `use FunLand.Combinable` does not understand options: #{inspect(unused_opts)}"
    end

    quote do
      @behaviour FunLand.Semicombinable
      @behaviour FunLand.Combinable

      unquote(collectable_implementation)
    end
  end

  defdelegate combine(a, b), to: FunLand.Semicombinable

  def empty(combinable)

  # stdlib modules
  for {stdlib_module, module} <- FunLand.Builtin.__stdlib__ do
    def empty(unquote(stdlib_module)) do
      apply(unquote(module), :empty, [])
    end
  end

  # custom modules
  def empty(combinable_module) when is_atom(combinable_module), do: combinable_module.empty

  # Stdlib structs
  for {stdlib_module, module} <- FunLand.Builtin.__stdlib_struct_modules__ do
    def empty(unquote(stdlib_module)) do
      apply(unquote(module), :empty, [])
    end
  end

  # Custom structs
  def empty(%combinable_module{}), do: combinable_module.empty

  # stdlib types
  use FunLand.Helper.GuardMacros
  for {guard, module} <- FunLand.Builtin.__builtin__ do
    def empty(combinable) when unquote(guard)(combinable) do
      apply(unquote(module), :empty, [])
    end
  end
end
