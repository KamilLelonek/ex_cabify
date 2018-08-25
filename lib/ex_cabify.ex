defmodule ExCabify do
  alias ExCabify.Storage.{Basket, Repo, Product}
  alias ExCabify.Discounts

  defstruct pricing_rules: nil, basket: %Basket{}

  def new(pricing_rules), do: %__MODULE__{pricing_rules: pricing_rules}

  def scan(%ExCabify{} = scanner, code) do
    code
    |> Repo.one()
    |> maybe_add(scanner)
  end

  def total(%ExCabify{basket: basket, pricing_rules: nil}), do: amount(basket)

  def total(%ExCabify{basket: basket, pricing_rules: pricing_rules}),
    do: Discounts.apply(basket, pricing_rules)

  def amount(%Basket{products: products}), do: Enum.reduce(products, 0, &calculate_amount/2)

  defp calculate_amount(%Product{price: price}, total), do: price + total

  defp maybe_add(nil, _scanner), do: {:error, :product_not_found}

  defp maybe_add(product, %ExCabify{basket: basket} = scanner),
    do: {:ok, %ExCabify{scanner | basket: Basket.put(basket, product)}}
end
