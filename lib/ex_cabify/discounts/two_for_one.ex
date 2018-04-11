defmodule ExCabify.Discounts.TwoForOne do
  @behaviour ExCabify.Discount

  @impl true
  def applicable_to, do: "VOUCHER"

  @impl true
  def minimal_count, do: 2
end
