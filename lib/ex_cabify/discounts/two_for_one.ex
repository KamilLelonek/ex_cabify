defmodule ExCabify.Discounts.TwoForOne do
  @behaviour ExCabify.Discounts

  alias ExCabify.{Basket, Storage.Product}

  @reduced_price 0.0
  @applicable_to "VOUCHER"
  @minimal_count 2

  @impl true
  def applicable_to, do: @applicable_to

  @impl true
  def minimal_count, do: @minimal_count

  @impl true
  def amount({applicable, not_applicable}, basket) do
    applicable
    |> Enum.chunk_every(minimal_count())
    |> Enum.split_with(&enough?/1)
    |> reduce_price(not_applicable, basket)
  end

  defp reduce_price({enough, not_enough}, not_applicable, basket) do
    enough
    |> Enum.map(&reduce_price/1)
    |> sum_products(not_enough, not_applicable, basket)
  end

  defp sum_products(reduced_price, not_enough, not_applicable, basket) do
    not_applicable
    |> Kernel.++(not_enough)
    |> Kernel.++(reduced_price)
    |> List.flatten()
    |> total(basket)
  end

  defp total(products, basket) do
    basket
    |> Map.replace!(:products, products)
    |> Basket.amount()
  end

  defp enough?(list)
       when length(list) >= @minimal_count,
       do: true

  defp enough?(_list), do: false

  defp reduce_price([product | rest]), do: [%Product{product | price: @reduced_price} | rest]
end
