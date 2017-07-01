defmodule FunLand.Builtin do
  @moduledoc false

  # Helper functions to ease FunLand implementations
  # for builtin types.


  @doc false
  @builtin_guards_list [
   {:is_success_tuple,  FunLand.Builtin.SuccessTuple},
   is_tuple: FunLand.Builtin.Tuple,
   is_atom: FunLand.Builtin.Atom,
   is_list: FunLand.Builtin.List,
   is_map: FunLand.Builtin.Map,
   is_bitstring: FunLand.Builtin.BitString,
   is_integer: FunLand.Builtin.Integer,
   is_float: FunLand.Builtin.Float,
   is_function: FunLand.Builtin.Function,
   is_pid: FunLand.Builtin.PID,
   is_port: FunLand.Builtin.Port,
   is_reference: FunLand.Builtin.Reference]
  def __builtin__ do
    @builtin_guards_list
  end

  def __stdlib_struct_modules__ do
    [
      {Range, Elixir.FunLand.Builtin.Range},
      {MapSet, Elixir.FunLand.Builtin.MapSet}
    ]
  end

  stdlib_modules = ~w{List Tuple Atom Map BitString Integer Float Function PID Port Reference Range MapSet}
  stdlib_modules_dispatch_list = for module <- stdlib_modules do
    {:"Elixir.#{module}", :"Elixir.FunLand.Builtin.#{module}"}
  end

  @doc false
  def __stdlib__ do
    unquote(stdlib_modules_dispatch_list)
  end

  @doc false
  def module_exports_function?(module_name, fun, arity) do
    case Code.ensure_compiled?(module_name) do
      true ->
        Enum.find(module_name.module_info(:exports), false, fn elem -> elem == {fun, arity} end) && true
      false ->
        Module.defines?(module_name, {fun, arity})
    end
  end
end
