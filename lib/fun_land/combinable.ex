defmodule FunLand.Combinable do
  @moduledoc """
  If an operation is can combine two elements, and there is a clearly defined `neutral`
  that can be used to keep the same element when used on an element.
  
  In Category Theory, something that is Combinable is called a *Monoid*.

  ## Examples

  integers-addition with 0 as neutral element forms a Monoid, also known as the Sum.
  integer-multiplication with 1 as neutral element forms a Monoid, also known as the Product.


  ## Fruit Salad Example

  Bowls that you can use to mix fruits in, are a monoid:

  The `combine` operation would be to put the fruits from Bowl A into Bowl B, keeping that one.
  The `neutral` operation would be to take an emtpy bowl.

  As can be seen, this follows the Combinable laws: 

  - left-identity: putting the fruits from an empty bowl into a bowl with appljes, would be the same as doing nothing (you still have 'a bowl with apples')
  - right-identity: putting the fruits from a bowl of apples into an empty bowl, would be the same as doing nothing (you still have 'a bowl with apples')


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


  defdelegate combine(a, b), to: FunLand.SemiCombinable

  def combine(a, b) do
    FunLand.Semicombinable.combine(a, b)
  end

  def neutral(combinable) do
    do_neutral(combinable)
  end

  # Lists
  defp do_neutral(combinable) when is_list(combinable), do: []
  defp do_neutral(List), do: []

  # Tuple
  defp do_neutral(combinable) when is_tuple(combinable), do: {}
  defp do_neutral(Tuple), do: {}
  
  # Binaries
  defp do_neutral(binary) when is_binary(binary), do: <<>>

  # Behaviour
  defp do_neutral(combinable = %combinable_module{}), do: combinable_module.neutral(combinable)
  defp do_neutral(_combinable = %{}), do: %{}
  
  # Map
  defp do_neutral(%{}), do: %{}
  defp do_neutral(Map), do: %{}


end