defmodule ExCabify.Basket do
  alias ExCabify.Storage.Product
  alias __MODULE__

  @type t :: __MODULE__

  defstruct products: []

  def new, do: %Basket{}

  def put(%Basket{products: products} = basket, %Product{} = product),
    do: %Basket{basket | products: [product | products]}

  def amount(%Basket{products: products}), do: Enum.reduce(products, 0, &calculate_amount/2)

  defp calculate_amount(%Product{price: price}, total), do: price + total
end
