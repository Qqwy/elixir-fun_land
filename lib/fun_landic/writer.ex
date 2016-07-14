defmodule FunLandic.Writer do
  use FunLand.Monad

  def __using__(_opts) do
    quote do

      use FunLand.Monad
      @behaviour FunLandic.Writer
    
      defdelegate map(writer, function), to: FunLandic.Writer
      defdelegate apply_with(writer_with_function, writer_with_value), to: FunLandic.Writer
      defdelegate chain(writer, function), to: FunLandic.Writer
      defdelegate wrap(), to: FunLandic.Writer
    end

  end
  
  @doc """
  This should return the Module name of the Combinable
  that should be used as the logging part of this Writer monad.

  This module's `neutral` value is used when a new instance of this Writer monad is made using `wrap/0`,
  and `combine` is used whenever the Writer's `apply_with/2` or `chain/2`
  """
  @callback log_combinable_module() :: module

  @doc """
  A Writer is represented by a 'value', a 'log' and the log_combinable_module??
  """
  defstruct [:val, :log]
  alias __MODULE__

  def map(%Writer{val: val, log: log}, fun), do: %Writer{val: fun.(val), log: log}

  def apply_with(%Writer{val: fun, log: log}, %Writer{val: val, log: log}) do
    # ???
  end

  def wrap() do

  end

  def chain(%Writer{val: val, log: log}, fun) do
    %Writer{val: result_val, log: result_log} = fun.(val)
    %Writer{val: result_val, log: FunLand.Combinable.combine(result_log, log)}
  end

end