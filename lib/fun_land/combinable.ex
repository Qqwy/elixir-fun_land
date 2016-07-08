defmodule FunLand.Combinable do
  @moduledoc """
  If an operation is can combine two elements, and there is a clearly defined `neutral`
  that can be used to keep the same element when used on an element.
  
  In Category Theory, something that is Combinable is called a *Monoid*.
  """

  @type combinable(_) :: FunLand.adt

  @callback neutral() :: combinable(a) when a: any

  def __using__(_opts) do
    quote do
      @behaviour FunLand.SemiCombinable
      @behaviour FunLand.Combinable

      # TODO: Is this proper? Can this be done? Or is it a lie?
      # Doesn't _into_ put values INTO a context?
      # defimpl Elixir.Collectable do
      #   def into(collectable_a, {:cont, collectable_b}) do
      #     FunLand.Collectable.combine(collectable_a, collectable_b)
      #   end

      #   def into(original) do
      #     {
      #       original, 
      #       fn 
      #         collectable_a, {:cont, collectable_b} ->
      #           FunLand.Collectable.combine(collectable_a, collectable_b)
      #         collectable_a, :done ->
      #           collectable_a
      #         collectable_a, :halt ->
      #           :ok
      #       end
      #     }
      #   end
      # end
    end
  end

  def combine(a, b) do
    FunLand.Semicombinable.combine(a, b)
  end

  def neutral(combinable) do
    do_neutral(combinable)
  end

  defp do_neutral(combinable) when is_list(combinable), do: []
  defp do_neutral(List), do: []
  defp do_neutral(combinable) when is_tuple(combinable), do: {}
  defp do_neutral(Tuple), do: {}
  defp do_neutral(combinable = %combinable_module{}), do: combinable_module.neutral(combinable)
  defp do_neutral(combinable = %{}), do: %{}
  defp do_neutral(Map), do: %{}

end