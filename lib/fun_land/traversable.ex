defmodule FunLand.Traversable do

  @moduledoc """
  TODO: Find out how to use this in a dynamically typed language.
  """

  @type traversable(_) :: FunLand.adt

  @callback traverse(traversable(a), module(), (a -> FunLand.Applicative.applicative(b))) :: FunLand.Applicative.applicative(traversable(b)) when a: any, b: any

  defmacro __using__(_opts) do
    quote do
      use FunLand.Mappable
      use FunLand.Reducable
      @behaviour FunLand.Traversable
    end
  end

  @doc """
  The `Module` argument is there to know what kind of
  Applicative structure to return in the case the `traversable`
  that is passed is empty (meaning that `fun` is never called).
  As many definitions of `traverse` are recursive, this case frequently occurs.

  Thus: `result_module` should be the same name as the name of thing you return from `fun`.
  """
  # Structs
  def traverse(traversable = %module{}, result_module, fun) do
    module.traverse(traversable, result_module, fun)
  end

  # Builtin
  for {guard, module} <- FunLand.Builtin.__builtin__ do
    def traverse(traversable, result_module, fun) when unquote(guard)(traversable) do
      apply(unquote(module),:traverse, [traversable, result_module, fun])
    end
  end
end
