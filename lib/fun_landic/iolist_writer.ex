defmodule FunLandic.IOListWriter do
  use FunLand
  use FunLandic.Writer

  # @moduledoc """

  # ## Example:

  #     require FunLandic.IOListWriter
  #     FunLandic.IOListWriter.monadic do
  #       let x = 20
  #       wrap(20)
  #       tell("test")
  #       y <- wrap(x*10)
  #       write(x+y, "#{x} plus #{y}")
  #     end

  # """

  def log_combinable_module, do: FunLand.Builtin.List


  # Override tell to allow binstrings as input, by first converting them to an IOlist
  def tell(info) when is_bitstring(info), do: super([info])
  def tell(info), do: super(info)
end
