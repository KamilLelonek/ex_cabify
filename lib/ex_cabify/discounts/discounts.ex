defmodule ExCabify.Discounts do
  alias ExCabify.Basket

  @callback applicable_to() :: String.t()
  @callback minimal_count() :: non_neg_integer()
  @callback apply(Basket.t()) :: non_neg_integer()

  def applies?(%Basket{products: products}, implementation) do
    Enum.count(products, &(&1.code == implementation.applicable_to())) >=
      implementation.minimal_count()
  end
end
