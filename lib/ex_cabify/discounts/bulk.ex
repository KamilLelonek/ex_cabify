defmodule ExCabify.Discounts.Bulk do
  @behaviour ExCabify.Discounts

  alias ExCabify.Storage.Product

  @reduced_price 19.0
  @applicable_to "TSHIRT"
  @minimal_count 3

  @impl true
  def applicable_to, do: @applicable_to

  @impl true
  def minimal_count, do: @minimal_count

  def reduced_price, do: @reduced_price

  @impl true
  def amount({applicable, not_applicable}, basket) do
    applicable
    |> Enum.count()
    |> maybe_enough(applicable, not_applicable, basket)
  end

  defp maybe_enough(count, applicable, not_applicable, basket)
       when count >= @minimal_count do
    applicable
    |> List.flatten()
    |> Enum.map(&reduce_price/1)
    |> sum_products(not_applicable, basket)
  end

  defp maybe_enough(_count, _applicable, _not_applicable, basket), do: ExCabify.amount(basket)

  defp sum_products(reduced_price, not_applicable, basket) do
    reduced_price
    |> Kernel.++(not_applicable)
    |> List.flatten()
    |> total(basket)
  end

  defp total(products, basket) do
    basket
    |> Map.replace!(:products, products)
    |> ExCabify.amount()
  end

  defp reduce_price(product), do: %Product{product | price: @reduced_price}
end
