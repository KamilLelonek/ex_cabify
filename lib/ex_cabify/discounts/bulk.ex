defmodule ExCabify.Discounts.Bulk do
  @behaviour ExCabify.Discounts

  alias ExCabify.Basket

  @impl true
  def applicable_to, do: "TSHIRT"

  @impl true
  def minimal_count, do: 3

  @impl true
  def apply(basket), do: Basket.amount(basket)
end
