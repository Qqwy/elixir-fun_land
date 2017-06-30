defmodule FunLandic.Writer do

  defmacro __using__(_opts) do
    quote location: :keep do
      use FunLand.Monad
      @behaviour FunLandic.Writer

      defstruct [:val, :log]

      def map(%__MODULE__{val: val, log: log}, fun), do: %__MODULE__{val: fun.(val), log: log}

      def wrap(val) do
        %__MODULE__{val: val, log: log_combinable_module().empty}
      end

      # TODO: Verify implementation
      def apply_with(%__MODULE__{val: fun, log: log}, %__MODULE__{val: val, log: log}) do
        %__MODULE__{val: result_val, log: result_log} = fun.(val)
        %__MODULE__{val: result_val, log: FunLand.Combinable.combine(result_log, log)}
      end

      def chain(%__MODULE__{val: val, log: log}, fun) do
        %__MODULE__{val: result_val, log: result_log} = fun.(val)
        %__MODULE__{val: result_val, log: FunLand.Combinable.combine(log, result_log)}
      end

      # Writer-specific

      def tell(info) do
        %__MODULE__{val: nil, log: info}
      end

      def write(action, info) do
        monadic do
          tell(info)
          wrap(action)
        end
      end

      defoverridable [map: 2, apply_with: 2, chain: 2, tell: 1, write: 2]

    end
  end

  @doc """
  This should return the Module name of the Combinable
  that should be used as the logging part of this Writer monad.

  This module's `empty` value is used when a new instance of this Writer monad is made using `wrap/0`,
  and `combine` is used whenever the Writer's `apply_with/2` or `chain/2`
  """
  @callback log_combinable_module() :: module

  @doc """
  A Writer is represented by a 'value', a 'log' and the log_combinable_module??
  """
  # defstruct [:val, :log]
  # alias __MODULE__

  # def map(%Writer{val: val, log: log}, fun), do: %Writer{val: fun.(val), log: log}

  # def apply_with(%Writer{val: fun, log: log}, %Writer{val: val, log: log}) do
  #   # ???
  # end

  # def wrap() do

  # end

  # def chain(%Writer{val: val, log: log}, fun) do
  #   %Writer{val: result_val, log: result_log} = fun.(val)
  #   %Writer{val: result_val, log: FunLand.Combinable.combine(result_log, log)}
  # end

end
