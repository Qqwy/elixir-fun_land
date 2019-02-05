defmodule FunLand.Traversable do

  @moduledoc """
  WARNING: This module is not completely stable yet,
  and should therefore
  not be used in practice yet.
  """

  @type traversable(a) :: FunLand.adt(a)

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


  # stdlib structs
  for {stdlib_module, module} <- FunLand.Builtin.__stdlib_struct_modules__ do
    def traverse(traversable = %unquote(stdlib_module){}, result_module_or_datatype, fun) do
      result_module = FunLand.Helper.map_datatype_to_module(result_module_or_datatype)
      apply(unquote(module), :traverse, [traversable, result_module, fun])
    end
  end


  # Custom Structs
  def traverse(traversable = %module{}, result_module_or_datatype, fun) do
    result_module = FunLand.Helper.map_datatype_to_module(result_module_or_datatype)
    module.traverse(traversable, result_module, fun)
  end

  # Builtin
  use FunLand.Helper.GuardMacros
  for {guard, module} <- FunLand.Builtin.__builtin__ do
    def traverse(traversable, result_module_or_datatype, fun) when unquote(guard)(traversable) do
      result_module = FunLand.Helper.map_datatype_to_module(result_module_or_datatype)
      apply(unquote(module), :traverse, [traversable, result_module, fun])
    end
  end
end
