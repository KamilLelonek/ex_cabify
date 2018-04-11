defmodule ExCabify.Discounts do
  alias ExCabify.Basket

  @callback applicable_to() :: String.t()
  @callback minimal_count() :: non_neg_integer()
  @callback amount(Basket.t()) :: non_neg_integer()

  def applies?(%Basket{products: products}, implementation) do
    Enum.count(products, &(&1.code == implementation.applicable_to())) >=
      implementation.minimal_count()
  end

  def apply(%Basket{} = basket, implementation) do
    basket
    |> applies?(implementation)
    |> maybe_discount(basket, implementation)
  end

  defp maybe_discount(false, basket, _implementation), do: Basket.amount(basket)
  defp maybe_discount(true, basket, implementation), do: implementation.amount(basket)
end
