defmodule ExCabify.PricingRules.BulkPurchase do
  @derive [Poison.Encoder]

  @enforce_keys ~w(applicable_count reduced_prize applicable_code)a

  defstruct @enforce_keys

  alias ExCabify.{Storage.Product, PricingRules.Refinement}

  defimpl Refinement do
    def run(pricing_rule, products),
      do: Enum.map(products, &reduce_price(&1, pricing_rule))

    defp reduce_price(product, %{reduced_prize: reduced_prize}),
      do: Product.update_price(product, reduced_prize)
  end
end
