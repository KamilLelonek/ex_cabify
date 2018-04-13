defmodule ExCabify.Discounts do
  alias ExCabify.{Basket, Storage.Product}

  @callback applicable_to() :: String.t()
  @callback minimal_count() :: non_neg_integer()
  @callback amount(
              {applicable :: list(Product.t()), not_applicable :: list(Product.t())},
              Basket.t()
            ) :: non_neg_integer()

  def applies?(%Basket{products: products}, implementation) do
    Enum.count(products, &(&1.code == implementation.applicable_to())) >=
      implementation.minimal_count()
  end

  def apply(%Basket{} = basket, implementation) do
    basket
    |> applies?(implementation)
    |> maybe_discount(basket, implementation)
  end

  defp maybe_discount(false, basket, _implementation), do: Basket.amount(basket)

  defp maybe_discount(true, %Basket{products: products} = basket, implementation) do
    products
    |> Enum.split_with(&applicable?(&1, implementation))
    |> implementation.amount(basket)
  end

  defp applicable?(%Product{code: code}, implementation),
    do: code == implementation.applicable_to()
end
