defmodule ExCabify.PricingRules.XForY do
  @derive [Poison.Encoder]

  @enforce_keys ~w(applicable_count reduced_count applicable_code)a

  defstruct @enforce_keys

  alias ExCabify.Storage.Product
  alias ExCabify.PricingRules.{Refinement, XForY}

  def new_price(%__MODULE__{applicable_count: total, reduced_count: discount}, old_price),
    do: old_price * discount / total

  defimpl Refinement do
    def run(%{applicable_count: applicable_count} = pricing_rule, products) do
      products
      |> Enum.chunk_every(applicable_count)
      |> reduce_prices(pricing_rule, applicable_count)
    end

    defp reduce_prices(products, pricing_rule, applicable_count) do
      products
      |> Enum.map(&maybe_reduce_price(&1, pricing_rule, applicable_count))
      |> List.flatten()
    end

    defp maybe_reduce_price(products, _, applicable_count)
         when length(products) != applicable_count,
         do: products

    defp maybe_reduce_price(products, pricing_rule, _applicable_count) do
      with [%Product{price: old_price} | _] <- products do
        pricing_rule
        |> XForY.new_price(old_price)
        |> update_price(products)
      end
    end

    defp update_price(new_price, products),
      do: Enum.map(products, &Product.update_price(&1, new_price))
  end
end
