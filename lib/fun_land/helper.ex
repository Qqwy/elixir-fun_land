defmodule FunLand.Helper do
  use FunLand.Helper.GuardMacros

  @moduledoc """
  FunLand Helper functions for some common Algorithmic Data Type implementations.
  """

  @doc """
  The identity function: Returns what was passed in, unchanged.
  """
  def id(x), do: x

  @doc """
  The constant function: Returns the first argument, regardless of the second argument.
  """
  def const(x, _y), do: x

  @doc """
  The constant function, reversed: Returns the second argument, regardless of the first argument.
  """
  def const_reverse(_x, y), do: y


  @doc """
  Returns the proper module to dispatch FunLand functions to, given a:

  - Builtin data type (dispatches to FunLand.Builtin.DataTypeModuleName).
  - Struct (dispatches to the struct name module).
  - module name (returns this module name).
  """
  def map_datatype_to_module(builtin_datatype)
  def map_datatype_to_module(module) when is_atom(module) do
    module
  end
  def map_datatype_to_module(%module{}) do
    module
  end
  # Module names of builtin data structures like `List`, `Map`, etc.
  for {stdlib_module, module} <- FunLand.Builtin.__stdlib__ do
    def map_datatype_to_module(unquote(stdlib_module)) do
      unquote(module)
    end
  end
  # Types like [], %{}, etc.
  for {guard, module} <- FunLand.Builtin.__builtin__ do
    def map_datatype_to_module(builtin_datatype) when unquote(guard)(builtin_datatype) do
      unquote(module)
    end
  end

end
