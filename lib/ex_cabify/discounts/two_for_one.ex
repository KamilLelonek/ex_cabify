defmodule ExCabify.Discounts.TwoForOne do
  @behaviour ExCabify.Discounts

  alias ExCabify.Basket

  @impl true
  def applicable_to, do: "VOUCHER"

  @impl true
  def minimal_count, do: 2

  @impl true
  def amount(basket), do: Basket.amount(basket)
end
