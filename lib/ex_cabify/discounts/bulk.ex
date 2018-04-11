defmodule ExCabify.Discounts.Bulk do
  @behaviour ExCabify.Discount

  @impl true
  def applicable_to, do: "TSHIRT"

  @impl true
  def minimal_count, do: 3
end
